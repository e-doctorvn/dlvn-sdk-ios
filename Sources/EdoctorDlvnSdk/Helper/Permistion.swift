//
//  Permistion.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 11/08/2023.
//

import AVFoundation
import UserNotifications
import UIKit

public func requestPermissions() {
    requestCameraPermission()
    requestMicrophonePermission()
}

public func requestCameraPermission() {
    AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
            print("Camera permission granted.")
        } else {
            if #available(iOS 14.3, *) {
                DirectCallManager.shared.endCallFast()
            } else {
                // Fallback on earlier versions
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                openAlertgoSetting(content: "Vui lòng cho phép quyền camera để thực hiện tư vấn video")
            }
            print("Camera permission denied.")
        }
    }
}

func checkCameraAndMicrophonePermissions() -> Bool {
    let cameraPermission = AVCaptureDevice.authorizationStatus(for: .video)
    let microphonePermission = AVCaptureDevice.authorizationStatus(for: .audio)
    
    return cameraPermission == .authorized && microphonePermission == .authorized
}

public func requestMicrophonePermission() {
    AVCaptureDevice.requestAccess(for: .audio) { granted in
        if granted {
            print("Microphone permission granted.")
        } else {
            if #available(iOS 14.3, *) {
                DirectCallManager.shared.endCallFast()
            } else {
                // Fallback on earlier versions
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                openAlertgoSetting(content: "Vui lòng cho phép quyền microphone để thực hiện tư vấn video")
            }

        }
    }
}

public func openAlertgoSetting(content: String) {
    
    let alertController = UIAlertController(title: "Thông báo", message: "\(content)", preferredStyle: .alert)

    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    alertController.addAction(settingsAction)
    
    if (ControlerAlert.shared.viewController == nil) {
        return
    }

    UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}
