//
//  File.swift
//  
//
//  Created by Bùi Đình Mạnh on 17/01/2024.
//

import Foundation
import SendbirdChatSDK
import UserNotifications
import UIKit

public func handleRegistriNotification(deviceToken: Data) {
    
    LocalStore.saveData(dataSave: deviceToken, key: .deviceToken)
    
    SendbirdChat.setPushTriggerOption(.all) { error in
        guard error == nil else {return}
    }
    
    let initParams = InitParams(
        applicationId: eDoctorAppId,
        isLocalCachingEnabled: true,
        logLevel: .none
    )
    
    SendbirdChat.initialize(params: initParams, migrationStartHandler: {
        // Xử lý khi quá trình di chuyển bắt đầu (nếu cần)
    }, completionHandler: { error in
        
        guard error == nil else {return}
        
        let userData: UserInfo? = LocalStore.getData(key: storeType.userInfoKey)
        if userData != nil {
            
            let currentUser = SendbirdChat.getCurrentUser()
            let tokenStore = UserDefaults.standard.string(forKey: "edrTokenAccountShortLink")
            
            if currentUser != nil && currentUser?.userId != userData?.userId && tokenStore != nil {
                SendbirdChat.connect(userId: currentUser!.userId, authToken: tokenStore) { user, error in
                    guard error == nil else {
                        return
                    }
                    
                    guard let token = SendbirdChat.getPendingPushToken() else { return }
                    SendbirdChat.unregisterPushToken(token) { error in
                        guard error == nil else {return}
                        SendbirdChat.disconnect() {
                            LocalStore.deleteData(key: .tokenAccountShortLink)
                            
                            SendbirdChat.connect(userId: userData!.userId, authToken: userData!.accessToken) { user, error in
                                guard error == nil else {return}
                                SendbirdChat.registerDevicePushToken(deviceToken, unique: false) { status, error in
                                    if error == nil {
                                        print("registerDevicePushToken success")
                                    }
                                }
                            }
                        }
   
                    }
                }
            } else {
                SendbirdChat.connect(userId: userData!.userId, authToken: userData!.accessToken) { user, error in
                    print("authen chat", userData!.userId)
                    guard error == nil else {return}
                    SendbirdChat.registerDevicePushToken(deviceToken, unique: false) { status, error in
                        if error == nil {
                            print("registerDevicePushToken success")
                        }
                    }
                }
            }
            

        }
    })
}

public func authenticateChatEDR() {
    let deviceToken: Data? = LocalStore.getData(key: .deviceToken)
    guard deviceToken == nil else {return}
    handleRegistriNotification(deviceToken: deviceToken!)
}

public func isEdrMessage(notification: UNNotification) -> Bool {
    let userInfo = notification.request.content.userInfo
    let sendbird = userInfo["sendbird"] as? NSDictionary
    if (sendbird == nil) {
        return false
    }
    let channel = sendbird?["channel"] as? NSDictionary
    let channel_url = channel?["channel_url"] as? String ?? ""
    
    if channel_url != "" {
        return true
    }
    
    return false
}

public func allowPushNotificationBackground(notification: UNNotification) -> Bool{
    
    let userInfo = notification.request.content.userInfo
    let sendbird = userInfo["sendbird"] as? NSDictionary
    if (sendbird == nil) {
        return true
    }
    let channel = sendbird?["channel"] as? NSDictionary
    let channel_url = channel?["channel_url"] as? String ?? ""
    
    if (channel_url == channel_url_active && UIApplication.shared.applicationState == UIApplication.State.active) {
        return false
    }
    
    return true
}


public func handlePressNotificatin(response: UNNotificationResponse) {
    
    if UIApplication.shared.applicationIconBadgeNumber > 0 {
           UIApplication.shared.applicationIconBadgeNumber -= 1
    }
    
    let userInfo = response.notification.request.content.userInfo
    let sendbird = userInfo["sendbird"] as? NSDictionary
    
    
    if sendbird == nil {
        return
    }
    
    let channel = sendbird?["channel"] as? NSDictionary
    let channel_url = channel?["channel_url"] as? String ?? ""
    
    DispatchQueue.main.async {
        let url = getUrlDefault() + "/phong-tu-van?channel=" + channel_url
        
        if ControlerAlert.shared.isActive {
            NotificationCenter.default.post(name: .handleLoadUrl, object: nil, userInfo: ["url": url])
        } else {
            openWebView(currentViewController: ControlerAlert.shared.viewController, withURL: url, isFromNotification: true)
        }
    }
}

public func removeChatDelegate(isShortLink: Bool? = false) {

    if isShortLink == true {
        print("vao1")
        let userLogged = SendbirdChat.getCurrentUser()
//        let tokenLogged: String? = LocalStore.getData(key: .tokenAccountShortLink)
        let tokenStore = UserDefaults.standard.string(forKey: "edrTokenAccountShortLink")
        
        if userLogged == nil || tokenStore == nil {
            return
        }
        
        SendbirdChat.connect(userId: userLogged!.userId , authToken: tokenStore) { user, error in
            print("vao2")
            guard error == nil else {
                return
            }
            
            guard let token = SendbirdChat.getPendingPushToken() else { return }
            SendbirdChat.unregisterPushToken(token) { error in
                print("vao3")
                guard error == nil else {return}
                SendbirdChat.disconnect()
                LocalStore.deleteData(key: .tokenAccountShortLink)
            }
        }
        return
    }
    
    let userData: UserInfo? = LocalStore.getData(key: storeType.userInfoKey)
    
    if userData == nil {return}
    
    if userData?.userId == nil {return}
    if userData?.accessToken == nil  {return}
    
    if SendbirdChat.getConnectState() == .open {
        SendbirdChat.connect(userId: userData!.userId , authToken: userData!.accessToken) { user, error in
            
            guard error == nil else {
                return
            }
            
            guard let token = SendbirdChat.getPendingPushToken() else { return }
            SendbirdChat.unregisterPushToken(token) { error in
                guard error == nil else {return}
                SendbirdChat.disconnect()
            }
        }
    }

}


