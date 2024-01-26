//
//  LocalStore.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 15/11/2023.
//

import Foundation

enum storeType: String {
    case EdoctorDLVNAccessTokenKey = "EdoctorDLVNAccessTokenKey"
    case voIpTokenKey = "edrVoIpTokenKey"
    case userInfoKey = "edrUserInfoKey"
    case dataLogin = "edrDataLogin"
    case deviceToken = "edrDeviceToken"
}

struct UserInfo: Codable {
    var appId: String
    var userId: String
    var accessToken: String
}

private func getType(key: storeType) -> Decodable {
    switch key {
        
    case storeType.EdoctorDLVNAccessTokenKey:
        return EdoctorOutputResult.self as! Decodable
    case .voIpTokenKey, .deviceToken:
        return Data.self as! Decodable
    case .userInfoKey:
        return UserInfo.self as! Decodable
    case .dataLogin:
        return DataLogin.self as! Decodable
    }
    
    
}

public class LocalStore {
    static func saveData(dataSave: Codable, key: storeType) {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(dataSave)
            UserDefaults.standard.set(data, forKey: key.rawValue)
        } catch {
            print("Lỗi khi lưu dữ liệu: \(error)")
        }
    }
    
    static func getData<T>(key: storeType) -> T? {
        do {
            if let data = UserDefaults.standard.data(forKey: key.rawValue) {
                let decoder = PropertyListDecoder()
                switch key {
                case .voIpTokenKey, .deviceToken:
                    return data as? T
                case storeType.EdoctorDLVNAccessTokenKey:
                    let accessToken = try decoder.decode(EdoctorOutputResult.self, from: data)
                    return accessToken as? T
                case .userInfoKey:
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    return userInfo as? T
                case .dataLogin:
                    let dataLogin = try decoder.decode(DataLogin.self, from: data)
                    return dataLogin as? T
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    static func deleteData(key : storeType) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    static func deleteAllData() {
        deleteData(key: .EdoctorDLVNAccessTokenKey)
        deleteData(key: .voIpTokenKey)
        deleteData(key: .userInfoKey)
        deleteData(key: .dataLogin)
//        deleteData(key: .deviceToken)
    }
}

struct DataLogin : Codable {
    let partnerid: String
    let deviceid: String
    let dcId: String
    let token: String
}

