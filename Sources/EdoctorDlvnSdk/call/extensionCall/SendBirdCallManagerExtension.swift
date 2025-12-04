//
//  SendBirdCallManagerExtension.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 16/08/2023.
//

import Foundation
import SendBirdCalls
import CallKit
import UIKit

//import AVFoundation


extension SendBirdCallManager: SendBirdCallDelegate, DirectCallDelegate {
    
    public func didStartRinging(_ call: DirectCall) {
        let name = "BS. \(call.caller?.nickname ?? "")"
        DoctorInfomation.shared.getDoctor(variables: call.customItems)
        call.delegate = self // To receive call event through `DirectCallDelegate`
        
//            AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        
        guard let uuid = call.callUUID else { return }
        guard CXCallManager.shared.shouldProcessCall(for: uuid) else { return }  // Should be cross-checked with state to prevent weird event processings
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: name)
        update.hasVideo = call.isVideoCall
        update.localizedCallerName = "BS. \(call.caller?.nickname ?? "...")"
        
        
        print("==>", call.customItems)
        DirectCallManager.shared.setDirectCall(directCall: call)
        
        if SendBirdCall.getOngoingCallCount() > 1 {
            print("==> getOngoingCallCount")
            // Allow only one ongoing call.
            CXCallManager.shared.reportIncomingCall(with: uuid, update: update) { _ in
                CXCallManager.shared.endCall(for: uuid, endedAt: Date(), reason: .declined)
            }
            call.end()
            if CallStatusManager.shared.callStatus != .none {
                DispatchQueue.main.async {
                    CallStatusManager.shared.setCallStatus(value: .none)
                }
            }
        } else {
            // Report the incoming call to the system
            DispatchQueue.main.async {
                CallStatusManager.shared.setCallStatus(value: .comming)
            }

            if UIApplication.shared.applicationState == UIApplication.State.active{
                DispatchQueue.main.async {
                    inCommingCall(call: call, isPushNoti: false)
                }

            } else {
                CXCallManager.shared.reportIncomingCall(with: uuid, update: update)
            }

        }
    }
    
    public func didEstablish(_ call: DirectCall) {
        CallStatusManager.shared.setCallStatus(value: .waiting)
    }
    
    public func didStartReconnecting(_ call: SendBirdCalls.DirectCall) {
        CallStatusManager.shared.setCallStatus(value: .reconnect)
    }
    
    public func didReconnect(_ call: SendBirdCalls.DirectCall) {
        if call.isVideoCall {
            CallStatusManager.shared.setCallStatus(value: .videoCalling)
        } else {
            CallStatusManager.shared.setCallStatus(value: .calling)
        }
    }
    
    public func didConnect(_ call: DirectCall) {

        DispatchQueue.main.async {
            if call.isVideoCall {
                CallStatusManager.shared.setCallStatus(value: .videoCalling)
            } else {
                CallStatusManager.shared.setCallStatus(value: .calling)
            }
        }
//        CountDownManager.shared.startCountDown(remainingTime: 60)


    }
    
    public func didRemoteAudioSettingsChange(_ call: DirectCall) {

    }
    
    public func didEnd(_ call: DirectCall) {
        
        var callId: UUID = UUID()
        if let callUUID = call.callUUID {
            callId = callUUID
        }
        
        
        CXCallManager.shared.endCall(for: callId, endedAt: Date(), reason: call.endResult)
        CountDownManager.shared.stopTimer()
        
        DirectCallManager.shared.endCall()

    }
    
    
}
