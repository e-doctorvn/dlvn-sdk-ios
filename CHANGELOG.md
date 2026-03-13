# dlvn-sdk-ios

EDR - DLVN Android IOS

Latest version: 1.3.2 (Updated: 13/03/2026)

## Version 1.3.2

- Bump `EdoctorDlvnSdk.podspec` lên `1.3.2` (update `version`, `source tag`, `readme` URL)
- Fix warning `switch must be exhaustive` cho `DirectCallEndResult.notConnected`
- Loại bỏ warning biến không sử dụng trong `Function.swift`
- Thay `keyWindow` deprecated bằng cách lấy active scene/window phù hợp iOS 13+
- Bổ sung file `LICENSE` (MIT)
- Cập nhật màu các action button trong màn hình video call sang tông xanh mới (`#0091FF`)
- Cập nhật một số asset giao diện call (`Welcome`, `phongtuvan`)
- Chuẩn hóa format tài liệu `README.md`

## Version 1.3.1

- Update webview header sang màu cố định `#1746FF`
- Update `SendbirdChatSDK` lên `4.37.1`
- Đồng bộ SPM/CocoaPods metadata với yêu cầu mới của Sendbird (`iOS 13+`, Swift `5.10+`)

## Version 1.3.0 ⚠️ BREAKING CHANGES

- **Minimum iOS version**: 11.0 → **13.0**
- **SendBirdCalls**: 1.10.13 → **1.10.22** (bản cuối cùng hỗ trợ CocoaPods)
- **SendbirdChatSDK**: 4.15.1 → **4.34.1**
- Fix typo "xãy ra" → "xảy ra"
- Thêm Example app để test SDK

> ⚠️ **Lưu ý**: Đây là bản cuối cùng hỗ trợ CocoaPods cho SendBirdCalls. Từ bản 2.0.0 sẽ chỉ hỗ trợ Swift Package Manager.

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
