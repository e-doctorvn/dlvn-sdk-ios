# dlvn-sdk-ios

EDR - DLVN Android IOS

Latest version: 1.3.4 (Updated: 30/09/2026)

## Unreleased

- Nâng SendbirdChatSDK từ 4.37.1 lên 4.39.11 (SPM) / 4.39.10 (bản mới nhất trên CocoaPods); SendbirdAuthSDK đi kèm lên 1.2.0.
- Giữ SendBirdCalls 1.10.22 để duy trì iOS 13 và CocoaPods; cập nhật yêu cầu build lên Xcode 26+ theo Sendbird Chat 4.39.x.

## Version 1.3.4

- Chuyển LIVE/SANDBOX sang `kh.daiichilife.com.vn` / `khuat.daiichilife.com.vn`, giữ nguyên URL path.
- WebView nhận diện internal link theo hostname chính xác `daiichilife.com.vn` hoặc subdomain có ranh giới `.`, thay kiểm tra `contains` và bỏ ngoại lệ path `/tu-van-suc-khoe`.
- Giữ internal link trong SDK WebView và mở external link bằng trình duyệt/ứng dụng hệ thống.
- Giữ yêu cầu iOS 14.3 cho booking/video; thêm test hostname giả, URL ngoài hệ thống và cấu hình môi trường.
- Cập nhật README, podspec và tham chiếu tag phát hành `v1.3.4`.

## Version 1.3.3

- Bump `EdoctorDlvnSdk.podspec` lên `1.3.3` (update `version`, `source tag`, `readme` URL)
- Cập nhật màu text "Lối tắt vào phòng tư vấn" thành `#1746FF` trong `WidgetList.swift`

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
