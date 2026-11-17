//
//  SdkBundle.swift
//  EdoctorDlvnSdk
//

import Foundation

extension Bundle {
    /// Bundle chứa resource (Media.xcassets, PrivacyInfo.xcprivacy) của SDK.
    /// SDK được phân phối qua Swift Package Manager nên resource nằm trong `Bundle.module`.
    static var edoctorSdk: Bundle { .module }
}
