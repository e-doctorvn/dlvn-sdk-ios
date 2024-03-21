//
//  Funtion.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 09/08/2023.
//

import Foundation
import SwiftUI
import SendBirdCalls

@available(iOS 14.3, *)
public func startVideoCallLayout(calleeId: String, isVideoCall: Bool) {
    requestPermissions()
    SendBirdCallManager.shared.makeCall(calleeId: calleeId, isVideoCall: isVideoCall)
    
    
    let startCallScreen = StartCallScreen()
    

    let hostingController = UIHostingController(rootView: startCallScreen)
    
    if let currentViewController = UIApplication.shared.windows.first?.rootViewController {
        hostingController.modalPresentationStyle = .fullScreen
        currentViewController.present(hostingController, animated: true, completion: nil)
    }
}


@available(iOS 14.3, *)
public func inCommingCall(call: DirectCall, isPushNoti: Bool?) {

    if isPushNoti != true {
        CallStatusManager.shared.setCallStatus(value: .comming)
    }
    
    let inCommingCall = IncommingCallScreen()
    

    let hostingController = UIHostingController(rootView: inCommingCall)
    hostingController.modalPresentationStyle = .fullScreen
    
    DispatchQueue.main.async {
        if let currentViewController = UIApplication.topViewController() {
            currentViewController.present(hostingController, animated: true, completion: nil)
        }
    }
}






