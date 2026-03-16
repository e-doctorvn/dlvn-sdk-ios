# dlvn-sdk-ios

EDR - DLVN Android IOS 

Latest version: 1.2.15 (Updated: 16/03/2026)

## Version 1.2.15
- Duy trì line phát hành iOS 11 (`release/ios11`) thay vì hạ `main`
- Bump `EdoctorDlvnSdk.podspec` lên `1.2.15` (update `version`, `source tag`, `readme` URL)
- Pin dependency Sendbird cho line iOS 11:
  - `SendBirdCalls` = `1.10.17`
  - `SendbirdChatSDK` = `4.15.1`
- Cập nhật hướng dẫn tích hợp line iOS 11 (`v1.2.x`) và line iOS 13+ (`v1.3.x`) trong `README.md`
- Update màu header webview sang `#1746FF`
- Update màu text widget "Lối tắt vào phòng tư vấn" sang `#1746FF`
- Bổ sung case `DirectCallEndResult.notConnected` để tránh warning switch không đầy đủ

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
