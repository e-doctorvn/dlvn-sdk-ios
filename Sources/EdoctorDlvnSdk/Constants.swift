//
//  File.swift
//  
//
//  Created by Bùi Đình Mạnh on 02/10/2023.
//
import Foundation

//config
public var env: Env = Env.SANDBOX


public let eDoctorAppId: String = "E8DBD7BE-354E-4E88-AE17-A43A4726FC52"
public let urlDefault: String = env == Env.SANDBOX ? urlDev : env == Env.LIVE ? urlPrd : urlTest
public let urlApiDefault: String = env == Env.LIVE ? urlapiPrd : urlApiDev

private let urlDev = "https://khuat.dai-ichi-life.com.vn/tu-van-suc-khoe"
private let urlPrd = "https://kh.dai-ichi-life.com.vn/tu-van-suc-khoe"
private let urlTest = "https://e-doctor.dev/tu-van-suc-khoe"

private let urlApiDev = "https://virtual-clinic.api.e-doctor.dev/"
private let urlapiPrd = "https://virtual-clinic.api.edoctor.io/"

public enum Env: String {
    case SANDBOX
    case LIVE
    case TEST
}

