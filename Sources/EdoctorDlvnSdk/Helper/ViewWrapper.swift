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

@available(iOS 14.3, *)
struct WebViewWrapper: UIViewControllerRepresentable, Equatable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let url = getUrlDefault() + "/phong-tu-van?channel=" + DoctorInfomation.shared.doctor.channelUrl!
        return  WebViewController(urlString: url, onClose: onClose)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func onClose() {
        CallStatusManager.shared.setCallStatus(value: .videoCalling)
    }


}
