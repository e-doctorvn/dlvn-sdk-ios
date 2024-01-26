//
//  SendBirdCallManager.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 08/08/2023.
//

import Foundation
import UIKit
import CallKit
import SendBirdCalls
import SendbirdChatSDK

@available(iOS 14.3, *)
public class SendBirdCallManager: NSObject {

    public static let shared = SendBirdCallManager()

    private override init() {
        super.init()
        SendBirdCall.configure(appId: eDoctorAppId)
        
        let initParams = InitParams(
            applicationId: eDoctorAppId,
            isLocalCachingEnabled: true,
            logLevel: .none
        )

        SendbirdChat.initialize(params: initParams) {

        }
    }

    public func configure(appId: String, userId: String, accessToken: String) {
        SendBirdCall.configure(appId: appId)
        login(userId: userId, accessToken: accessToken)
    }
    
    public func firstConfigure() {
        SendBirdCall.configure(appId: eDoctorAppId)
        let userData: UserInfo? = LocalStore.getData(key: storeType.userInfoKey)
        if userData != nil {
            login( userId: userData!.userId, accessToken: userData!.accessToken)
            authenticateChatEDR()
        } else {
            APIService.shared.startRequest(graphQLQuery: sendbirdAccount) { data, error in
                if error != nil || data == nil {
                    return
                }
                
                if let jsonData = data!.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let data = json["data"] as? [String: Any],
                           let account = data["account"] as? [String: Any],

                           let thirdParty = account["thirdParty"] as? [String: Any],
                           let sendbird = thirdParty["sendbird"] as? [String: Any],
                           let accountId = account["accountId"] as? String,
                           let token = sendbird["token"] as? String {
                            LocalStore.saveData(dataSave: UserInfo(appId: eDoctorAppId, userId: accountId, accessToken: token), key: storeType.userInfoKey)
                            self.login( userId: accountId, accessToken: token)
                            authenticateChatEDR()
                        }

                    } catch {
                        print("Error: \(error)")
                    }
                }
                
            }
        }
    }
    
    public func configure(appId: String) {
        SendBirdCall.configure(appId: appId)
    }
    
    public func login( userId: String, accessToken: String) {

        let params = AuthenticateParams(userId: userId, accessToken: accessToken)
        SendBirdCall.authenticate(with: params) { (user, error) in
            print("authenticate", userId)
            PushRegistryHandler.shared.registerForDelegate()
            LocalStore.saveData(dataSave: UserInfo(appId: eDoctorAppId, userId: userId, accessToken: accessToken), key: storeType.userInfoKey)

        }
        SendBirdCall.addDelegate(self, identifier: "com.edoctor.AppTestSDK")

    }

//    deinit {
//        SendBirdCall.removeDelegate(identifier: "com.edoctor.AppTestSDK")
//    }
    
    public func makeCall(calleeId: String, isVideoCall: Bool) {
        CallStatusManager.shared.setCallStatus(value: .waiting)

        let callOptions = CallOptions(isAudioEnabled: true, isVideoEnabled: true, localVideoView: DirectCallManager.shared.localVideoView, remoteVideoView: DirectCallManager.shared.remoteVideoView, useFrontCamera: true)
        let dialParams = DialParams(calleeId: calleeId, isVideoCall: true, callOptions: callOptions, customItems: [:])
        
        SendBirdCall.dial(with: dialParams) { call, error in
            
            DispatchQueue.main.async {
                DirectCallManager.shared.directCall = call
                DirectCallManager.shared.directCall?.updateLocalVideoView(DirectCallManager.shared.localVideoView)
                DirectCallManager.shared.directCall?.updateRemoteVideoView(DirectCallManager.shared.remoteVideoView)
                DirectCallManager.shared.directCall?.delegate = self
            }


        }
    }
    
    public func removeVoIPPushToken() {
        
        guard let voIpToken: Data = LocalStore.getData(key: storeType.voIpTokenKey) else {return}
        
        SendBirdCall.unregisterVoIPPush(token : voIpToken) { (error) in
     
        }
    }
    
}




