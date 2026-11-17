# DlvnSdk

Version: **2.0.0** (tag `v2.0.0`)

## Hướng dẫn tích hợp SDK

## Tính năng

- mở webview tư vấn sức khỏe
- call native

## Yêu cầu: iOS 13.0+

- Xcode 26+ để build với Sendbird Chat 4.39.x; Swift language mode vẫn là Swift 5.
- Dùng Xcode 26.x khi cần deployment target iOS 13; Xcode 27 chỉ hỗ trợ deployment target từ iOS 15.
- Dependency đã đối chiếu ngày 01/10/2026:

| Thư viện | Phiên bản (SPM) |
| --- | --- |
| SendbirdChatSDK | 4.39.11 trở lên, dưới 5.0 |
| SendbirdAuthSDK (gián tiếp qua Chat) | 1.2.0 |
| SendBirdCalls | 1.10.22 |
| SendBirdWebRTC (gián tiếp qua Calls) | 1.8.1 |

Giữ Calls 1.10.22 để hỗ trợ iOS 13; Calls 1.12.x yêu cầu iOS 14+.

## SDK Integration

- Đảm bảo tài khoản GitHub của bạn đã được thêm vào repo này.
- Tạo Personal Access Token (quyền đọc repo): https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

> ⚠️ Từ bản **2.0.0** SDK chỉ phát hành qua **Swift Package Manager**. CocoaPods không còn được hỗ trợ; bản cuối cùng trên CocoaPods là `1.4.0`.

## Cài đặt bằng Swift Package Manager

1. Trong Xcode: **File → Add Package Dependencies…**
2. Nhập URL `https://github.com/e-doctorvn/dlvn-sdk-ios`
3. Chọn Dependency Rule **Up to Next Major Version** từ `2.0.0`.
4. Khi Xcode hỏi đăng nhập, nhập username GitHub và **access token** (không phải mật khẩu). Có thể thêm sẵn tài khoản tại **Xcode → Settings → Accounts → + → GitHub**.
5. Chọn product `EdoctorDlvnSdk` cho target app → **Add Package**.

Hoặc trong `Package.swift`:

```swift
.package(url: "https://github.com/e-doctorvn/dlvn-sdk-ios.git", from: "2.0.0")
```

**CI (repo private):** cấp quyền đọc qua `~/.netrc`:

```
machine github.com
  login <github-username>
  password <access-token>
```

và build với `xcodebuild -resolvePackageDependencies` trước khi build/test.

### Chuyển từ CocoaPods sang SPM

App đang dùng `pod 'EdoctorDlvnSdk'` (≤ 1.4.0) cần chuyển sang SPM để nhận bản 2.0.0 trở đi:

1. Xoá `pod 'EdoctorDlvnSdk'` (và các pod `SendBirdCalls`, `SendbirdChatSDK` nếu app khai báo trực tiếp) khỏi `Podfile`, chạy `pod install` (hoặc `pod deintegrate` nếu không còn pod nào).
2. Thêm SDK bằng SPM như trên. Nếu app dùng Sendbird trực tiếp, thêm Sendbird cũng qua SPM — **không** để Sendbird đồng thời ở cả Pods và SPM (gây trùng symbol/class).
3. App đã dùng SDK qua SPM ở bản 1.x: đổi Dependency Rule sang `from: "2.0.0"` (rule "Up to Next Major" từ 1.x không tự lên 2.0.0).
4. `import EdoctorDlvnSdk` (Swift) và `@import EdoctorDlvnSdk;` (Objective-C) giữ nguyên.
5. Kiểm tra lại: mở WebView, đăng nhập, gọi video (CallKit/PushKit), ảnh ở widget và màn hình gọi.

### Icon CallKit

Màn hình cuộc gọi hệ thống (CallKit) dùng ảnh `icLogoSymbolInverse` từ asset catalog **của app host**. Thêm ảnh template (đơn sắc, nền trong suốt) với tên này vào `Assets.xcassets` của app để hiển thị logo.

## Sử dụng

Import:

```swift
import EdoctorDlvnSdk
```

mở webView

```sh
openWebView(currentViewController: self)
```

| Parameter             | Type              | Description                                                                   |
| :-------------------- | :---------------- | :---------------------------------------------------------------------------- |
| currentViewController | UIViewController? | UIViewController to display, if nil will use first view of rootViewController |
| urlString             | String?           | URL to open in WebView. If nil, use the initialized value in SDK              |
| data                  | [String: Any]?    | Login data. If nil, use the data saved by the last successful `DLVNSendData` / `authenticateEDR` |

Sau khi `DLVNSendData` hoặc `authenticateEDR` thành công, SDK lưu lại thông tin đăng nhập. Mở webView không truyền `data` vẫn tự đăng nhập (giống SDK Android). Thông tin này bị xoá khi gọi `deauthenticateEDR`.

Gọi hàm:

```sh
let data : [String: Any] = [
                    "company": "",
                    "partner_code": "",
                    "partnerid": "45f63H33771b42f1b08b7f9a50e6bd8a",
                    "deviceid": "3e030eb9-63e6-4be1-ae0e-940f6b7e2c61",
                    "dcId": "19E2ADB7-91A8-4C32-821B-31A03AD32C89",
                    "token": "26f63593771b42f1b08b7f9a50e6dc7c"
                ]
DLVNSendData(data: data) { status, error in
    print(status)
}
```

| Parameter | Type          | Description |
| :-------- | :------------ | :---------- |
| data      | [String: Any] | Required    |

Kết quả:
-- `true`: Lấy accesstoken thành công
-- `false`: Gọi hàm không thành công

```sh
// xóa accessToken
deleteAccessToken()
```

```sh
// chuyển đổi môi trường
changeEnv(envUpdate: Env.SANDBOX) // Env is enum: LIVE || SANBOX
```

### Domain và điều hướng WebView

- LIVE: `https://kh.daiichilife.com.vn/tu-van-suc-khoe`
- SANDBOX: `https://khuat.daiichilife.com.vn/tu-van-suc-khoe`
- Link HTTP/HTTPS có hostname chính xác `daiichilife.com.vn` hoặc subdomain kết thúc bằng `.daiichilife.com.vn` được mở trong SDK WebView.
- Link ngoài hệ thống tiếp tục mở bằng trình duyệt/ứng dụng hệ thống. Path, query hoặc fragment chứa `/tu-van-suc-khoe` hay tên domain không làm URL trở thành internal.
- SDK vẫn hỗ trợ iOS 13.0+; luồng booking/video tiếp tục yêu cầu iOS 14.3+.

## Gọi mở webView cho objective-C

```sh
    @import EdoctorDlvnSdk;

    - (void)myFunction:(String *)urlString {
    NSLog(@"urlString %@", urlString);
    }

    NSDictionary *data = @{
        @"partnerid": @"45f63H33771b42f1b08b7f9a50e6bd8a",
        @"deviceid": @"3e030eb9-63e6-4be1-ae0e-940f6b7e2c61",
        @"dcId": @"19E2ADB7-91A8-4C32-821B-31A03AD32C89",
        @"token": @"26f63593771b42f1b08b7f9a50e6dc7c"
    };
    DlvnSdk *dlvn = [[DlvnSdk alloc] init];


    [dlvn openWebViewOCWithCurrentViewController:self withURL:nil data:nil onSdkRequestLogin:^(String *urlString) {
        [self myFunction:urlString];
    }];
```

- CurrentViewController == nil thì sẽ lấy "first view of rootViewController"
- withURL == nil thì sẽ lấy url mặc định (truyền url để xử lý phần notification)
- data == nil thì dùng thông tin đăng nhập đã lưu từ lần gọi DLVNSendData / authenticateEDR thành công gần nhất; chưa gọi các hàm này thì sẽ ko login được
- onSdkRequestLogin: hàm này sẽ callback lại khi request login data là url

---

## -- CALL NATIVE

## Yêu cầu:

- iOS 14.3 trở lên
- Swift 5.10 trở lên
- Xcode 26 trở lên

## Cấu hình

- Bật "Voice over IP" trong Signing & Capabilities -> "Background Modes"
  ![N|Solid](https://firebasestorage.googleapis.com/v0/b/application-18caf.appspot.com/o/Screenshot%202023-12-13%20at%2010.25.15.png?alt=media&token=d69c0009-f0f3-4d4b-98eb-ab15db07dc0b)
- Thêm quyền Microphone và Camera:
  <key>NSCameraUsageDescription</key>
  <key>NSMicrophoneUsageDescription</key>

---

## -- CHAT Notification

bật Remoote notification trong Background Modes

- Lúc login thành công gọi hàm : authenticateEDROC vs param là data chứa thông tin tài khoản đó
- Hàm handleRegistriNotification sẽ được gọi trong : application(\_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) vs param là deviceToken

```swift
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        handleRegistriNotification(deviceToken: deviceToken)
    }
```

- Xử lý hiện notification như thế này:

```swift
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if isEdrMessage(notification: notification) && allowPushNotificationBackground(notification: notification) {
            completionHandler([.banner, .sound, .badge])
        } else {
            //DC app handle
        }

    }
```

- Xử lý click vào thông báo như thế này:

```swift
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handlePressNotificatin(response: response)
    }
```

- Khi đăng xuất gọi hảm này để hủy các sự kiện:

```swift
    deauthenticateEDROC
```

## Phát hành (dành cho maintainer)

> ⚠️ **Dùng Xcode 26.x để lint/push lên CocoaPods.** Xcode 27 chỉ hỗ trợ deployment target từ iOS 15, nên `pod spec lint` / `pod trunk push` sẽ lỗi `IPHONEOS_DEPLOYMENT_TARGET is set to 13.0, but the range of supported deployment target versions is 15.0 to ...` vì SDK (iOS 13) và Sendbird (iOS 11–13) đặt target thấp hơn. Lỗi này không phải do SDK.

Chọn Xcode 26.x riêng cho lệnh bằng `DEVELOPER_DIR` (không cần đổi `xcode-select`):

```sh
export DEVELOPER_DIR=/Applications/Xcode-26.2.0.app/Contents/Developer
```

Các bước:

1. Cập nhật `spec.version`, `:tag` và `spec.readme` trong `EdoctorDlvnSdk.podspec`, phiên bản trong README và CHANGELOG; merge vào `main`.
2. Gắn tag `vX.Y.Z` lên commit trên `main` và push tag (SPM dùng tag này).
3. Kiểm tra podspec build được: `LANG=en_US.UTF-8 pod spec lint EdoctorDlvnSdk.podspec --allow-warnings`
4. Đăng nhập trunk bằng tài khoản owner (`pod trunk register <email>`, xác nhận qua email), rồi đẩy pod: `LANG=en_US.UTF-8 pod trunk push EdoctorDlvnSdk.podspec --allow-warnings`
5. Kiểm tra: `LANG=en_US.UTF-8 pod trunk info EdoctorDlvnSdk`

Cảnh báo `ENABLE_USER_SCRIPT_SANDBOXING` khi lint đến từ app tạm CocoaPods tự sinh, có thể bỏ qua.
