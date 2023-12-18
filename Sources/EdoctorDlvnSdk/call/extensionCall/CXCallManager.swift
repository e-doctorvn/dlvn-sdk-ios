import Foundation
import CallKit
import UIKit
import AVFoundation
import SendBirdCalls

@available(iOS 14.0, *)
class CXCallManager: NSObject {
    static let shared = CXCallManager()
    
    var currentCalls: [CXCall] { self.controller.callObserver.calls }
    
    private let provider: CXProvider
    private let controller = CXCallController()
    
    override init() {
        self.provider = CXProvider.default
        
        super.init()
        
        self.provider.setDelegate(self, queue: .main)
    }
    
    func shouldProcessCall(for callId: UUID) -> Bool {
        return !self.currentCalls.contains(where: { $0.uuid == callId })
    }
}

@available(iOS 14.0, *)
extension CXCallManager { // Process with CXProvider
    func reportIncomingCall(with callID: UUID, update: CXCallUpdate, completionHandler: ((Error?) -> Void)? = nil) {
        self.provider.reportNewIncomingCall(with: callID, update: update) { (error) in
            completionHandler?(error)
        }
    }
    
    func endCall(for callId: UUID, endedAt: Date, reason: DirectCallEndResult) {
        guard let endReason = reason.asCXCallEndedReason else { return }

        self.provider.reportCall(with: callId, endedAt: endedAt, reason: endReason)
    }
    
    func connectedCall(_ call: DirectCall) {
        self.provider.reportOutgoingCall(with: call.callUUID!, connectedAt: Date(timeIntervalSince1970: Double(call.startedAt)/1000))
    }
}

@available(iOS 14.0, *)
extension CXCallManager { // Process with CXTransaction
    func requestTransaction(_ transaction: CXTransaction, action: String = "") {
        self.controller.request(transaction) { error in
            guard error == nil else {
                print("Error Requesting Transaction: \(String(describing: error))")
                return
            }
            // Requested transaction successfully
        }
    }
    
    func startCXCall(_ call: DirectCall, completionHandler: @escaping ((Bool) -> Void)) {
        guard let calleeId = call.callee?.userId else {
            DispatchQueue.main.async {
                completionHandler(false)
            }
            return
        }
        let handle = CXHandle(type: .generic, value: calleeId)
        let startCallAction = CXStartCallAction(call: call.callUUID!, handle: handle)
        startCallAction.isVideo = call.isVideoCall
        
        let transaction = CXTransaction(action: startCallAction)
        
        self.requestTransaction(transaction)
        
        DispatchQueue.main.async {
            completionHandler(true)
        }
    }
    
    func endCXCall(_ call: DirectCall) {
        let endCallAction = CXEndCallAction(call: call.callUUID!)
        let transaction = CXTransaction(action: endCallAction)
        
        self.requestTransaction(transaction)
    }
}

@available(iOS 14.0, *)
extension CXCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) { }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // MARK: SendBirdCalls - SendBirdCall.getCall()
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        if call.myRole == .caller {
            provider.reportOutgoingCall(with: call.callUUID!, startedConnectingAt: Date(timeIntervalSince1970: Double(call.startedAt)/1000))
        }
        
        action.fulfill()
    }
    
    @available(iOS 14.0, *)
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        SendBirdCall.authenticateIfNeed { [weak call] (error) in
            guard let call = call, error == nil else {
                action.fail()
                return
            }
            
            DispatchQueue.main.async {
                DirectCallManager.shared.directCall = call
                DirectCallManager.shared.acceptCall(isMicOn: true, isCamOn: true)
                APIService.shared.startRequest(graphQLQuery: eClinicApproveCall, variables: call.customItems) { data, error in }
            }
            
            if call.isVideoCall {
                CallStatusManager.shared.setCallStatus(value: .videoCalling)
            } else {
                CallStatusManager.shared.setCallStatus(value: .calling)
            }
            
            DispatchQueue.main.async {
                if #available(iOS 14.3, *) {
                    inCommingCall(call: call, isPushNoti: true)
                } else {
                    // Fallback on earlier versions
                }
            }
            
            action.fulfill()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
        
        // For decline in background
        DispatchQueue.global().async {
            backgroundTaskID = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = .invalid
            }
            
            if call.endResult == DirectCallEndResult.none || call.endResult == .unknown {
                SendBirdCall.authenticateIfNeed { [weak call] (error) in
                    guard let call = call, error == nil else {
                        action.fail()
                        return
                    }
                    APIService.shared.startRequest(graphQLQuery: eClinicExpireRinging, variables: call.customItems) { data, error in }
                    call.end {
                        action.fulfill()
                        // End background task
                        UIApplication.shared.endBackgroundTask(backgroundTaskID)
                        backgroundTaskID = .invalid
                    }
                }
            } else {
                action.fulfill()
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = SendBirdCall.getCall(forUUID: action.callUUID) else {
            action.fail()
            return
        }
        
        // MARK: SendBirdCalls - DirectCall.muteMicrophone / .unmuteMicrophone()
        action.isMuted ? call.muteMicrophone() : call.unmuteMicrophone()
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) { }
    
    // In order to properly manage the usage of AVAudioSession within CallKit, please implement this function as shown below.
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        SendBirdCall.audioSessionDidActivate(audioSession)
    }
    
    // In order to properly manage the usage of AVAudioSession within CallKit, please implement this function as shown below.
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        SendBirdCall.audioSessionDidDeactivate(audioSession)
    }
}

extension DirectCallEndResult {
    var asCXCallEndedReason: CXCallEndedReason? {
        switch self {
        case .connectionLost, .timedOut, .acceptFailed, .dialFailed, .unknown:
            return .failed
        case .completed, .canceled:
            return .remoteEnded
        case .declined:
            return .declinedElsewhere
        case .noAnswer:
            return .unanswered
        case .otherDeviceAccepted:
            return .answeredElsewhere
        case .none: return nil
        @unknown default: return nil
        }
    }
}

@available(iOS 14.0, *)
extension CXProviderConfiguration {
    // The app's provider configuration, representing its CallKit capabilities
    static var `default`: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration()
        if let image = UIImage(named: "icLogoSymbolInverse") {
            providerConfiguration.iconTemplateImageData = image.pngData()
        }
        // Even if `.supportsVideo` has `false` value, SendBirdCalls supports video call.
        // However, it needs to be `true` if you want to make video call from native call log, so called "Recents"
        // and update correct type of call log in Recents
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        
        // Set up ringing sound
        // If you want to set up other sounds such as dialing, reconnecting and reconnected, see `AppDelegate+SoundEffects.swift` file.
         providerConfiguration.ringtoneSound = "Ringing.mp3"
        
        return providerConfiguration
    }
}

@available(iOS 14.0, *)
extension CXProvider {
    static var `default`: CXProvider {
        CXProvider(configuration: .`default`)
    }
}

