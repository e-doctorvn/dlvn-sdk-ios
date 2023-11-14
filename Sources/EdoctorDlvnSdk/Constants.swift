//
//  Constants.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 29/08/2023.
//

import Foundation

public var env: Env = Env.SANDBOX


public let eDoctorAppId: String = "0BEF9C57-BA3B-474E-A40F-62B027AA47F6"
private let urlDev: String = "https://khuat.dai-ichi-life.com.vn/tu-van-suc-khoe"
private let urlPrd: String = "https://kh.dai-ichi-life.com.vn/tu-van-suc-khoe"

private let urlApiDev: String = "https://virtual-clinic.api.e-doctor.dev/"
private let urlapiPrd: String = "https://virtual-clinic.api.edoctor.io/"


public func getUrlDefault() -> String {
    return env == Env.SANDBOX ? urlDev : urlPrd
}

public func getApiDefault() -> String {
    return env == Env.SANDBOX ? urlApiDev : urlapiPrd
}

public enum Env {
    case SANDBOX
    case LIVE
}

public let closeWebView = "close-webview"
public let goBack = "go-back"
public let sharedArticle = "shared-article"
public let requestLoginNative = "request-login-native"


