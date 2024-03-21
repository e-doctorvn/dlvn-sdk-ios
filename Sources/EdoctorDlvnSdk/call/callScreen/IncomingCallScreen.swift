//
//  IncommingCallLayout.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 09/08/2023.
//

import SwiftUI

@available(iOS 14.3, *)
struct IncommingCallScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var directCallManager = DirectCallManager.shared
    @ObservedObject var callStatusManager = CallStatusManager.shared
     
    var body: some View {
        VStack {
            if (callStatusManager.callStatus == .videoCalling || callStatusManager.callStatus == .waiting || callStatusManager.callStatus == .reconnect) {
                VideoCallScreen()
                    .environmentObject(directCallManager)
                    .environmentObject(callStatusManager)
            } else if callStatusManager.callStatus == .videoCallWithChat || callStatusManager.callStatus == .finish {
                VideoCallWithChatLayout()
                    .environmentObject(directCallManager)
            } else {
                IncomingVideoCallLayout()
                    .environmentObject(directCallManager)
                    .environmentObject(callStatusManager)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onDisappear {
            if let presentingViewController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
        .onChange(of: callStatusManager.callStatus) { newValue in
            UIApplication.shared.isIdleTimerDisabled = false
            if newValue == .none {
                onClose()
                DoctorInfomation.shared.reset()
            } else if newValue == .finish {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    DoctorInfomation.shared.reset()
                }
            }
        }
    }
    
    func onClose () {
        presentationMode.wrappedValue.dismiss()
    }
}
