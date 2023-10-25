//
//  DLVNAccessToken.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 20/10/2023.
//

import Foundation

public class DLVNAccessToken {
    private static let EdoctorDLVNAccessTokenKey = "EdoctorDLVNAccessTokenKey"
    
    static func saveData(edoctorOutputResult: EdoctorOutputResult) {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(edoctorOutputResult)
            UserDefaults.standard.set(data, forKey: EdoctorDLVNAccessTokenKey)
        } catch {
            print("Lỗi khi lưu dữ liệu: \(error)")
        }
    }
    
    static func getData() -> EdoctorOutputResult? {
        if let data = UserDefaults.standard.data(forKey: EdoctorDLVNAccessTokenKey) {
            do {
                let decoder = PropertyListDecoder()
                let userInfo = try decoder.decode(EdoctorOutputResult.self, from: data)
                return userInfo
            } catch {
                print("Lỗi khi đọc dữ liệu: \(error)")
            }
        }
        return nil
    }
    
    static func deleteData() {
        UserDefaults.standard.removeObject(forKey: EdoctorDLVNAccessTokenKey)
    }
}


