//
//  CallStatusManager.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 15/08/2023.
//

import Foundation


public class CallStatusManager : ObservableObject {
    
    static let shared = CallStatusManager()
    
    @Published var callStatus: CallStatus = .null
    
    public func setCallStatus(value : CallStatus) {
        callStatus = value
    }
    
}
