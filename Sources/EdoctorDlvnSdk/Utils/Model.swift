//
//  Model.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 19/10/2023.
//

import Foundation


public struct DLVNInputData: Codable {
    public let company: String?
    public let partner_code: String?
    public let partnerid: String?
    public let deviceid: String
    public let dcId: String
    public let token: String
    public let role: String?
}

public struct EdoctorInputData: Codable {
    public let signature: String
    public let dcId: String
    public let data: String
}

public struct EdoctorOutputDataServer: Codable {
    public let data: EdoctorOutputData
}

public struct EdoctorOutputData: Codable {
    public let dlvnAccountInit: EdoctorOutputResult?
}

public struct EdoctorOutputResult: Codable {
    public let phone: String?
    public let accessToken: String?
}

public struct EdoctorData: Codable {
    public let deviceid: String
    public let partnerid: String?
    public let dcid: String
    public let token: String
}

