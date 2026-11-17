//
//  SdkBundle.swift
//  EdoctorDlvnSdk
//

import Foundation

extension Bundle {
    /// Bundle chứa resource (Media.xcassets) của SDK.
    /// - SPM: SDK được link tĩnh, resource nằm trong bundle sinh ra `Bundle.module`.
    /// - CocoaPods: resource được copy vào bundle chứa class của SDK.
    static var edoctorSdk: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        return Bundle(for: WebViewController.self)
        #endif
    }
}
