//
//  sdkMain.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 08/08/2023.
//

import SwiftUI
import WebKit
import Foundation
import SendBirdCalls


public func openWebView(currentViewController: UIViewController? = nil, withURL urlString: String? = getUrlDefault() ,data: [String: Any]? = nil, onSdkRequestLogin: ((String) -> Void)? = nil) {
    
    let webview = WebViewController(urlString: urlString ?? getUrlDefault(), onClose: nil, data: data, onSdkRequestLogin: onSdkRequestLogin)
    
    webview.modalPresentationStyle = .fullScreen

    if (currentViewController != nil) {
        currentViewController!.present(webview, animated: true)
    } else if let currentViewController = UIApplication.shared.windows.first?.rootViewController {
        currentViewController.present(webview, animated: true)
    }
}


public func deleteAccessToken() {
    LocalStore.deleteData(key: storeType.EdoctorDLVNAccessTokenKey)
    LocalStore.deleteData(key: storeType.userInfoKey)
}

public func clearWebViewCache() {
    deleteAccessToken()
    deleteCache()
}

public func changeEnv(envUpdate: Env) {
    env = envUpdate
}

private func deleteCache() {
    let websiteDataStore = WKWebsiteDataStore.default()

    let dataTypes = Set([WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage])

    let date = Date(timeIntervalSince1970: 0)
    websiteDataStore.removeData(ofTypes: dataTypes, modifiedSince: date) {
        print("Cache đã được xóa.")
    }
}

public func requestPermission() {
    requestPermissions()
}


public func DLVNSendData(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
    
    do {
        let decoder = JSONDecoder()
        let jsonDataInput = try JSONSerialization.data(withJSONObject: data, options: [])
        let dataInput = try decoder.decode(DLVNInputData.self, from: jsonDataInput)
        
        let edoctorData = EdoctorData(deviceid: dataInput.deviceid, partnerid: dataInput.partnerid, dcid: dataInput.dcId, token: dataInput.token)
        let jsonData = try JSONEncoder().encode(edoctorData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let edoctorInputData = EdoctorInputData(signature: "", dcId: dataInput.dcId, data: jsonString)
            getData(dataInput: edoctorInputData) { dataOutput, error in
                if let error = error {
                    print("Lỗi: \(error)")
                    completion(false, error)
                } else {
//                    SendBirdCallManager.shared.firstConfigure()
                    completion(true, nil)
                }
            }
        }

    } catch {
        completion(false, error)
    }
    
}


func getData(dataInput: EdoctorInputData, completion: @escaping (EdoctorOutputResult?, Error?) -> Void) {

    let apiUrlString = "\(getApiDefault())graphql"
    
    guard let apiUrl = URL(string: apiUrlString) else {
        print("URL không hợp lệ")
        return
    }
    
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"

    
    let graphQLQuery = """
    mutation DLVNAccountInit($data: String, $signature: String, $dcId: String) { dlvnAccountInit(data: $data, signature: $signature, dcId: $dcId) { phone accessToken }}
    """
    
    let variables: [String: Any] = [
        "signature": dataInput.signature,
        "dcId": dataInput.dcId,
        "data": dataInput.data
    ]
    
    
    let graphQLRequest: [String: Any] = ["query": graphQLQuery, "variables": variables]
    
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: graphQLRequest) {
        request.httpBody = jsonData
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("Bearer YourAccessToken", forHTTPHeaderField: "Authorization")

    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(nil, error)
        } else if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Phản hồi từ server: \(responseString)")
            }
            do {
                let dataOutput = try decodeJSON(data: data, type: EdoctorOutputDataServer.self)
                if dataOutput.data.dlvnAccountInit == nil {
                    completion(nil, NSError(domain: "Edoctor", code: 800, userInfo: ["message": "Data trả về null"]))
                } else {
                    let result = EdoctorOutputResult(phone: dataOutput.data.dlvnAccountInit?.phone, accessToken: dataOutput.data.dlvnAccountInit?.accessToken)
                    LocalStore.saveData(dataSave: result, key: storeType.EdoctorDLVNAccessTokenKey)
                    completion(result, nil)
                }
            } catch {
                print("Lỗi phân tích dữ liệu JSON: \(error)")
                completion(nil, error)
            }
        }
    }
    
    task.resume()
}

@available(iOS 14.3, *)
public func removeCallConfig() {
    SendBirdCallManager.shared.removeVoIPPushToken()
    SendBirdCall.removeAllDelegates()
    SendBirdCall.deauthenticate { error in
            if let error = error {
                print("Error logging out from SendBird Calls: \(error.localizedDescription)")
            } else {
                print("Logged out from SendBird Calls successfully")
            }
        }
    PushRegistryHandler.shared.deregisterPushRegistryDelegate()
    LocalStore.deleteData(key: storeType.voIpTokenKey)
    clearWebViewCache()
}

@available(iOS 14.3, *)
public func logInSendBird(userId: String, accessToken: String) {
    SendBirdCallManager.shared.login(userId: userId, accessToken: accessToken)
}

@available(iOS 14.3, *)
public func configAppId(appId: String) {
    SendBirdCallManager.shared.configure(appId: appId)
}

@available(iOS 14.3, *)
public func configAppIdAndLogin(appId: String, userId: String, accessToken: String) {
    SendBirdCallManager.shared.configure(appId: appId, userId: userId, accessToken: accessToken)
}

@available(iOS 14.3, *)
public func firstConfigureCall() {
    SendBirdCallManager.shared.firstConfigure()
}

@available(iOS 14.3, *)
public func callConfig(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
    
    do {
        let decoder = JSONDecoder()
        let jsonDataInput = try JSONSerialization.data(withJSONObject: data, options: [])
        let dataInput = try decoder.decode(DLVNInputData.self, from: jsonDataInput)
        
        let edoctorData = EdoctorData(deviceid: dataInput.deviceid, partnerid: dataInput.partnerid, dcid: dataInput.dcId, token: dataInput.token)
        let jsonData = try JSONEncoder().encode(edoctorData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            let edoctorInputData = EdoctorInputData(signature: "", dcId: dataInput.dcId, data: jsonString)
            getData(dataInput: edoctorInputData) { dataOutput, error in
                if let error = error {
                    print("Lỗi: \(error)")
                    completion(false, error)
                } else {
                    SendBirdCallManager.shared.firstConfigure()
                    completion(true, nil)
                }
            }
        }

    } catch {
        completion(false, error)
    }
    
}

public func openAlert(from viewController: UIViewController, content: String?) {
    let alertController = UIAlertController(title: "Thông báo", message: "\(content ?? "Vui Lòng upgrade OS 14+ để xử dụng chức năng này!")", preferredStyle: .alert)

    let okAction = UIAlertAction(title: "Đồng ý", style: .default) { (action) in
        
    }
    alertController.addAction(okAction)

    viewController.present(alertController, animated: true, completion: nil)
}

@available(iOS 14.3, *)
public func addDirectCallSounds(dialingName: String? = nil, reconnectingName: String? = nil, reconnectedName: String? = nil) {
    // SendBirdCall.setDirectCallSound("Ringing.mp3", forKey: .ringing)
    if (dialingName != nil) {
        SendBirdCall.addDirectCallSound(dialingName!, forType: .dialing)
    }
    
    if (reconnectingName != nil) {
        SendBirdCall.addDirectCallSound(reconnectingName!, forType: .reconnecting)
    }

    if (reconnectedName != nil) {
        SendBirdCall.addDirectCallSound(reconnectedName!, forType: .reconnected)
    }
}

@available(iOS 14.3, *)
public func removeDirectCallSounds() {
    SendBirdCall.removeDirectCallSound(forType: .dialing)
    SendBirdCall.removeDirectCallSound(forType: .reconnecting)
    SendBirdCall.removeDirectCallSound(forType: .reconnected)
}

@objc public class DlvnSdk: NSObject {
    @objc public func openWebViewOC(currentViewController: UIViewController? = nil, withURL urlString: String? = getUrlDefault(), data: [String: Any]? = nil) {
        openWebView(currentViewController: currentViewController, withURL: urlString, data: data)
    }
    
    @objc public func openWebViewOC(currentViewController: UIViewController? = nil, withURL urlString: String? = getUrlDefault(), data: [String: Any]? = nil, onSdkRequestLogin: @escaping ((String) -> Void)) {
        openWebView(currentViewController: currentViewController, withURL: urlString, data: data, onSdkRequestLogin: onSdkRequestLogin)
    }
    

    @objc public func DLVNSendDataOC(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        DLVNSendData(data: data) { dataOutput, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    @objc public func requestPermissionOC() {
        requestPermission()
    }
    
    @objc public func clearWebViewCacheOC() {
        clearWebViewCache()
    }
    
    @objc public func changeLiveEnv() {
        env = Env.LIVE
    }
    
    @objc public func changeDevEnv() {
        env = Env.SANDBOX
    }
    
    @available(iOS 14.3, *)
    @objc public func addDirectCallSoundsOC(dialingName: String? = nil, reconnectingName: String? = nil, reconnectedName: String? = nil) {
        addDirectCallSounds(dialingName: dialingName, reconnectingName: reconnectingName, reconnectedName: reconnectedName)
    }
    
    @available(iOS 14.3, *)
    @objc public func callConfigOC(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        callConfig(data: data) { dataOutput, error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    @available(iOS 14.3, *)
    @objc public func removeCallConfigOC() {
        removeCallConfig()
    }
    
    @available(iOS 14.3, *)
    @objc public func firstConfigureCallOC() {
        firstConfigureCall()
    }
    
}

