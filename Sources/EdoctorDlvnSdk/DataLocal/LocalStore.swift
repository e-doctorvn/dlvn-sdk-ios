//
//  LocalStore.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 15/11/2023.
//

import Foundation

enum storeType: String {
    case EdoctorDLVNAccessTokenKey = "EdoctorDLVNAccessTokenKey" // lưu thông tin đăng nhập token dlvn/ edr
    case voIpTokenKey = "voIpTokenKey" // lưu token thông báo
    case userInfoKey = "userInfoKey"   // lưu thông tin đăng nhập sendbird Call
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
    case .voIpTokenKey:
        return Data.self as! Decodable
    case .userInfoKey:
        return UserInfo.self as! Decodable
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
                case .voIpTokenKey:
                    return data as? T
                case storeType.EdoctorDLVNAccessTokenKey:
                    let accessToken = try decoder.decode(EdoctorOutputResult.self, from: data)
                    return accessToken as? T
                case .userInfoKey:
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    return userInfo as? T
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
}

