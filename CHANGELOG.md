# dlvn-sdk-ios

EDR - DLVN Android IOS

Latest version: 2.0.0 (Updated: 17/11/2026)

## Version 2.0.0 ⚠️ BREAKING CHANGES

- **Chỉ phân phối qua Swift Package Manager.** Xoá `EdoctorDlvnSdk.podspec`; bản cuối cùng trên CocoaPods là 1.4.0. Hướng dẫn chuyển: mục "Chuyển từ CocoaPods sang SPM" trong README.
- App đã dùng SPM ở bản 1.x: đổi Dependency Rule sang `from: "2.0.0"`.
- Resource của SDK luôn lấy qua `Bundle.module`.
- `isCocoapod` được đánh dấu deprecated, không còn tác dụng.
- Không đổi API, iOS tối thiểu (13.0) và phiên bản Sendbird.

## Version 1.4.0

- **Swift Package Manager là kênh phân phối chính.** CocoaPods chuyển sang deprecated, sẽ ngừng hỗ trợ từ bản 2.0.0.
- Fix ảnh SDK (`room`, `enterRoom`, `backgroundCall`, `chatImage`) không hiển thị khi tích hợp qua SPM: resource được lấy qua `Bundle.module` khi build bằng SPM.
- Khai báo rõ resource trong `Package.swift` (`Media.xcassets`, `PrivacyInfo.xcprivacy`).
- Thêm Privacy Manifest (`PrivacyInfo.xcprivacy`) khai báo UserDefaults (lý do `CA92.1`); CocoaPods đóng gói trong bundle `EdoctorDlvnSdk_Privacy`.
- Thêm CI GitHub Actions: build + test package, build app Example.
- README: hướng dẫn SPM, xác thực repo private trên CI, hướng dẫn chuyển từ CocoaPods, ghi chú icon CallKit `icLogoSymbolInverse`.

## Version 1.3.5

- WebView mở không truyền `data` (`openWebView(currentViewController:)`) giờ tự đăng nhập bằng thông tin đã lưu từ `DLVNSendData` / `authenticateEDR` thành công gần nhất, giống SDK Android. Thông tin này bị xoá khi gọi `deauthenticateEDR`.
- Bỏ đoạn lưu thông tin đăng nhập dùng ép kiểu `as! String` trong WebView (có thể crash khi thiếu `partnerid`).
- Nâng SendbirdChatSDK từ 4.37.1 lên 4.39.11 (SPM) / 4.39.10 (bản mới nhất trên CocoaPods); SendbirdAuthSDK đi kèm lên 1.2.0.
- Giữ SendBirdCalls 1.10.22 để duy trì iOS 13 và CocoaPods; cập nhật yêu cầu build lên Xcode 26+ theo Sendbird Chat 4.39.x.
- Cập nhật README, podspec và tham chiếu tag phát hành `v1.3.5`.

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
