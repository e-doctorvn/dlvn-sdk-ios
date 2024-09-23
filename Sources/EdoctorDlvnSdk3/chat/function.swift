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
    if #available(iOS 14.3, *) {
        SendBirdCallManager.shared.firstConfigure()
    } else {
        // Fallback on earlier versions
    }
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


public func handlePressNotificatin(currentViewController: UIViewController? = nil, response: UNNotificationResponse) {
    
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
        
        if #available(iOS 13.0, *) {
            if (CallStatusManager.shared.callStatus != .none && CallStatusManager.shared.callStatus != .videoCallWithChat) {
                CallStatusManager.shared.setCallStatus(value: .videoCallWithChat)
            } else {
                openWebView(currentViewController: currentViewController, withURL: url, isFromNotification: true)
            }
        } else {
            openWebView(currentViewController: currentViewController, withURL: url, isFromNotification: true)
        }
    }
}

public func removeChatDelegate(isShortLink: Bool? = false) {

    if isShortLink == true {
        let userLogged = SendbirdChat.getCurrentUser()
//        let tokenLogged: String? = LocalStore.getData(key: .tokenAccountShortLink)
        let tokenStore = UserDefaults.standard.string(forKey: "edrTokenAccountShortLink")
        
        if userLogged == nil || tokenStore == nil {
            return
        }
        
        SendbirdChat.connect(userId: userLogged!.userId , authToken: tokenStore) { user, error in
            guard error == nil else {
                return
            }
            
            guard let token = SendbirdChat.getPendingPushToken() else { return }
            SendbirdChat.unregisterPushToken(token) { error in
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


