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
        DispatchQueue.main.async {
            if CallStatusManager.shared.callStatus == .finish {
                CallStatusManager.shared.setCallStatus(value: .none)
            } else {
                CallStatusManager.shared.setCallStatus(value: .videoCalling)
            }
        }
    }
}

//extension UIApplication {
//    class func topViewController() -> UIViewController? {
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
//            return nil
//        }
//        return topViewController(for: window.rootViewController)
//    }
//    
//    private class func topViewController(for viewController: UIViewController?) -> UIViewController? {
//        if let navigationController = viewController as? UINavigationController {
//            return topViewController(for: navigationController.visibleViewController)
//        }
//        if let tabBarController = viewController as? UITabBarController {
//            if let selectedViewController = tabBarController.selectedViewController {
//                return topViewController(for: selectedViewController)
//            }
//        }
//        if let presentedViewController = viewController?.presentedViewController {
//            return topViewController(for: presentedViewController)
//        }
//        return viewController
//    }
//}

func topMostController() -> UIViewController? {
    let activeWindowScene = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
    let keyWindow = activeWindowScene?.windows.first(where: \.isKeyWindow)
        ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)

    var topController = keyWindow?.rootViewController
    
    while let presentedViewController = topController?.presentedViewController {
        topController = presentedViewController
    }
    
    return topController
}

extension UIViewController {
    var isBeingPresentedModally: Bool {
        if let presentingViewController = presentingViewController {
            return presentingViewController.presentedViewController == self
        }
        return false
    }
}
