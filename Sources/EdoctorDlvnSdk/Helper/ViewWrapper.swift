//
//  SendBirdVideoViewWrapper.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 14/08/2023.
//

import SwiftUI
import SendBirdCalls

@available(iOS 13.0, *)
struct SendBirdVideoViewWrapper: UIViewRepresentable {
    let sendBirdVideoView: SendBirdVideoView

    func makeUIView(context: Context) -> UIView {
        return sendBirdVideoView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
      
    }
}

@available(iOS 13.0, *)
struct WebViewWrapper: UIViewControllerRepresentable, Equatable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        return  WebViewController(urlString: "https://e-doctor.dev/phase2/tu-van-suc-khoe/phong-tu-van", onClose: onClose)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func onClose() {
        CallStatusManager.shared.setCallStatus(value: .videoCalling)
    }


}
