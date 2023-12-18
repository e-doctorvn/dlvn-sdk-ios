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
            } else if callStatusManager.callStatus == .finish || callStatusManager.callStatus == .none{
                FinnishCallLayout()
            } else if callStatusManager.callStatus == .videoCallWithChat {
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
            // Đóng hosting controller khi SwiftUI view biến mất
            if let presentingViewController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
        .onChange(of: callStatusManager.callStatus) { newValue in
            if newValue == .none {
                onClose()
            }
        }
    }
    
    func onClose () {
        presentationMode.wrappedValue.dismiss()
    }
}
