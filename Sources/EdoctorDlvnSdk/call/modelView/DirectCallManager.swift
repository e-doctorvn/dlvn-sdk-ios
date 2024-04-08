//
//  DirectCallManager.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 09/08/2023.
//

import Foundation
import SendBirdCalls
import UIKit

@available(iOS 13.0, *)
public class DirectCallManager: UIViewController, ObservableObject {
    
    public func didConnect(_ call: SendBirdCalls.DirectCall) {
        if call.isVideoCall {
            CallStatusManager.shared.setCallStatus(value: .videoCalling)
        } else {
            CallStatusManager.shared.setCallStatus(value: .calling)
        }
    }
    
    public func didEnd(_ call: SendBirdCalls.DirectCall) {
        DirectCallManager.shared.endCall()
    }
    
    
    
    static let shared = DirectCallManager()

    @Published var directCall: DirectCall?
    
    
    public var localVideoView = SendBirdVideoView(frame: CGRect(x: 0, y: 0, width: 150, height: 300))
    public var remoteVideoView = SendBirdVideoView(frame: CGRect(x: 0, y: 0, width: 60, height: 80))
    
    
    
    public func setDirectCall(directCall: DirectCall) {
        self.directCall = directCall
    }
    
    public func resetDirectCall() {
        self.directCall = nil
    }
    
    public func endCall() {
        directCall?.end()
        CallStatusManager.shared.setCallStatus(value: .finish)
        CountDownManager.shared.stopTimer()
        resetDirectCall()
    }
    
    public func endCallFast() {
        CallStatusManager.shared.setCallStatus(value: .none)
        directCall?.end()
        CountDownManager.shared.stopTimer()
        resetDirectCall()
    }
    
    public func acceptCall(isMicOn: Bool, isCamOn: Bool) {
        let callOption = CallOptions(isAudioEnabled: isMicOn, isVideoEnabled: isCamOn, localVideoView: localVideoView, remoteVideoView: remoteVideoView)
        
        localVideoView = SendBirdVideoView(frame: CGRect(x: 0, y: 0, width: 120, height: 160))
        remoteVideoView = SendBirdVideoView(frame: CGRect(x: 0, y: 0, width: 240, height: 320))
        
        let param = AcceptParams(callOptions: callOption)
        directCall?.accept(with: param)
        
        CallStatusManager.shared.setCallStatus(value: .waiting)
        
//        CountDownManager.shared.startCountDown(remainingTime: 300)
        
        directCall?.updateLocalVideoView(localVideoView)
        directCall?.updateRemoteVideoView(remoteVideoView)
    }
    
    @available(iOS 14.3, *)
    public func startCall(calleeId: String,  isVideoCall: Bool) {

        
        CallStatusManager.shared.setCallStatus(value: .waiting)
        
        SendBirdCallManager.shared.makeCall(calleeId: calleeId, isVideoCall: isVideoCall)
        directCall?.updateLocalVideoView(localVideoView)
        directCall?.updateRemoteVideoView(remoteVideoView)
        
    }
    
}

