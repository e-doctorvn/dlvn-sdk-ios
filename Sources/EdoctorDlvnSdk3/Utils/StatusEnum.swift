//
//  CallStatus.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 11/08/2023.
//

import Foundation

public enum CallStatus {
    
    case null
    case none
    case comming
    case waiting
    case calling
    case videoCalling
    case reconnect
    case finish
    case videoCallWithChat
    
}

public func getTextCallStatus(callStatus: CallStatus) -> String {
    switch callStatus {
    case .waiting:
        return "Xin vui lòng chờ trong giây lát"

    case .reconnect:
        return "Đang kết nối lại..."

    default:
        return "Đang xử lý..."
    }
}

