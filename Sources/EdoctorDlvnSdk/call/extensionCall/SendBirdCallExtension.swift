//
//  SendBirdCallExtension.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 16/08/2023.
//

import Foundation
import SendBirdCalls

extension SendBirdCall {
    /**
     This method uses when,
     - the user makes outgoing calls from native call history("Recents")
     - the provider performs the specified end(decline) or answer call action.
     */
    static func authenticateIfNeed(completionHandler: @escaping (Error?) -> Void) {
        guard SendBirdCall.currentUser == nil else {
            completionHandler(nil)
            return
        }
        
        guard let userInfo: UserInfo = LocalStore.getData(key: storeType.userInfoKey ) else {return}
        SendBirdCall.configure(appId: eDoctorAppId)
        let params = AuthenticateParams(userId: userInfo.userId, accessToken: userInfo.accessToken)
        SendBirdCall.authenticate(with: params) { (_, error) in
            completionHandler(error)
        }
    }

}
