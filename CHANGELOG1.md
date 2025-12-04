# dlvn-sdk-ios

EDR - DLVN Android IOS 

Latest version: 2.0.0 (Updated: 04/12/2024)

## Version 2.0.0 🚀 SPM ONLY
- **⚠️ BREAKING**: Chỉ hỗ trợ **Swift Package Manager**, không còn hỗ trợ CocoaPods
- **Minimum iOS version**: 13.0 → **14.0**
- **SendBirdCalls**: 1.10.22 → **1.11.1**
- **SendbirdChatSDK**: 4.34.1 (giữ nguyên)
- Loại bỏ các `@available(iOS 14.3, *)` checks không cần thiết
- Cập nhật Example app tương thích iOS 14+

### Migration Guide
```swift
// Podfile - KHÔNG CÒN HỖ TRỢ
// pod 'EdoctorDlvnSdk'

// Package.swift - SỬ DỤNG CÁCH NÀY
dependencies: [
    .package(url: "https://github.com/e-doctorvn/dlvn-sdk-ios.git", from: "2.0.0")
]
```

## Version 1.3.0 ⚠️ BREAKING CHANGES
- **Minimum iOS version**: 11.0 → **13.0**
- **SendBirdCalls**: 1.10.13 → **1.10.22** (bản cuối cùng hỗ trợ CocoaPods)
- **SendbirdChatSDK**: 4.15.1 → **4.34.1**
- Fix typo "xãy ra" → "xảy ra"
- Thêm Example app để test SDK

> ⚠️ **Lưu ý**: Đây là bản cuối cùng hỗ trợ CocoaPods cho SendBirdCalls. Các bản sau sẽ chỉ hỗ trợ Swift Package Manager.

## Version 1.2.14
- Ignore bug code -999 from webview

## Version 1.0.18
- update lại key bị trùng trong sessionStorage

## Version 1.0.17
- xử lý login theo session
- thay đổi câu thông báo lỗi tiếng việt

## Version 1.0.14
- handle event back click + share from dlvn
- disable zoom in webview

## Version 1.0.13
- update function to clearWebViewCache call when logout app
- WebView is now able to perform: User (not logged in) types his question, then hits "Submit" -> back to DC app to request login but save current form data in WebView.

## Version 1.0.12
- Addding logOutWebView function
- token is now a required field in JSONObject of DLVNSendData function

## Version 1.0.11
- Changing flow of login case 2: Using DC app's login module
- Adding setOnSdkRequestLogin function
