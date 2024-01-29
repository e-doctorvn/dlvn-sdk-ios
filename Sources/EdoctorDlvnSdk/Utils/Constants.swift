//
//  Constants.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 29/08/2023.
//

import Foundation


public var env: Env = Env.SANDBOX



public var targetVersionBooking: String = "14.3"
public var isCocoapod: Bool = false


public let eDoctorAppId: String = "0BEF9C57-BA3B-474E-A40F-62B027AA47F6"
private let urlDev: String = "khuat.dai-ichi-life.com.vn"
private let urlPrd: String = "kh.dai-ichi-life.com.vn"

private let urlApiDev: String = "https://virtual-clinic.api.e-doctor.dev/"
private let urlapiPrd: String = "https://virtual-clinic.api.edoctor.io/"


public func getUrlDefault() -> String {
    let url = env == Env.SANDBOX ? urlDev : urlPrd
    return "https://" + url + "/tu-van-suc-khoe"
}

public func getDomain() -> String {
    let url = env == Env.SANDBOX ? urlDev : urlPrd
    return url
}

public func getApiDefault() -> String {
    return env == Env.SANDBOX ? urlApiDev : urlapiPrd
}

public enum Env {
    case SANDBOX
    case LIVE
}

public let closeWebView = "close-webview"
public let requiredClose = "required-close"
public let goBack = "go-back"
public let sharedArticle = "shared-article"
public let requestLoginNative = "request-login-native"
public let activeChannelUrl = "active-channel-url"
public let requestUpdateApp = "request-update-app"


