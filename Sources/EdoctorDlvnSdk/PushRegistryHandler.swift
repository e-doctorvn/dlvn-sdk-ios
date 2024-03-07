//
//  PushRegistryHandler.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 09/08/2023.
//

import PushKit
import SendBirdCalls
import UIKit

class PushRegistryHandler: NSObject, PKPushRegistryDelegate, UIApplicationDelegate {
    static let shared = PushRegistryHandler()

    private override init() {
        super.init()
    }

    func registerForDelegate() {
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = Set([.voIP])
    }
    
    func deregisterPushRegistryDelegate() {
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = nil
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        
        SendBirdCall.registerVoIPPush(token: credentials.token, unique: true) { (error) in
            guard error == nil else { return }
            print("registerVoIPPush update")
            LocalStore.saveData(dataSave: credentials.token, key: storeType.voIpTokenKey)
        }
    }
    

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        // Xử lý khi push token bị vô hiệu hóa
        LocalStore.deleteData(key: storeType.voIpTokenKey)
        print("pushRegistry push token đã bị vô hiệu hóa")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        // Xử lý khi nhận được push notification
//        print("okok", convertDictionaryToString(dictionary: payload.dictionaryPayload))
        SendBirdCall.pushRegistry(registry, didReceiveIncomingPushWith: payload, for: type, completionHandler: { callUUID in
            print("pushRegistry callUUID\(String(describing: callUUID))")
        })

    }
}


