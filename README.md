# DlvnSdk

Version: **1.3.4** (tag `v1.3.4`)

## Hướng dẫn tích hợp SDK

## Tính năng

- mở webview tư vấn sức khỏe
- call native

## Yêu cầu: iOS 13.0+

- Xcode 26+ để build với Sendbird Chat 4.39.x; Swift language mode vẫn là Swift 5.
- Dùng Xcode 26.x khi cần deployment target iOS 13; Xcode 27 chỉ hỗ trợ deployment target từ iOS 15.
- Dependency đã đối chiếu ngày 01/10/2026:

| Thư viện | Swift Package Manager | CocoaPods |
| --- | --- | --- |
| SendbirdChatSDK | 4.39.11 trở lên, dưới 5.0 | ~> 4.39.10 |
| SendbirdAuthSDK (gián tiếp qua Chat) | 1.2.0 | 1.2.0 |
| SendBirdCalls | 1.10.22 | ~> 1.10.22 |
| SendBirdWebRTC (gián tiếp qua Calls) | 1.8.1 | ~> 1.8.1 |

Chat 4.39.11 chưa có trên CocoaPods; 4.39.10 là bản mới nhất trên kênh này tại thời điểm cập nhật.
Giữ Calls 1.10.22 để hỗ trợ iOS 13 và CocoaPods; Calls 1.12.3 yêu cầu iOS 14+ và không hỗ trợ CocoaPods.
Package `API/` chứa mã Apollo độc lập, không được SDK hoặc Example tham chiếu, nên không nằm trong lần nâng dependency này.

## SDK Integration

-- Đảm bảo bạn đã được thêm tài khoản vào repo này
-- Hướng dẫn lấy access Token tại đây : https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

-- Dưới đây là 2 cách để tích hợp sdk vào dự án

## -- Cách 1 dùng Cocoapod:

- Thêm đoạn mã vào podfile dự án :
  ```swift
  target 'MyApp' do
    pod 'EdoctorDlvnSdk', '~> 1.3.4'
  end
  ```
- sau đó chạy lệnh "pod install" để cài đặt
- Nhập username
- Nhập password là access token đã tạo ở bước trên (không phải nhập password git)

* lưu ý: Nếu dùng cách này thì phải mở file .xcworkspace

## -- Cách 2 Package Dependency:

- Nhấn vào biểu tượng "+" tại mục `Farmeworks, Libraries, and Embedded Content`.
- Chọn Add Other...
- Chọn Add Package Dependency
- Nhập "https://github.com/e-doctorvn/dlvn-sdk-ios" vào ô tìm kiếm
- Chọn version `1.3.4` (tag `v1.3.4`).
- Nhập userName và access token được tạo ở bước trên
- ![N|Solid](https://firebasestorage.googleapis.com/v0/b/application-18caf.appspot.com/o/Screenshot%202023-08-30%20at%2016.17.54.png?alt=media&token=1604d9b7-8c55-42db-9645-82260b5fa423)
- Nhấn Add Package

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
- data == nil thì sẽ ko login được
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
