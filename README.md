# DlvnSdk
## Hướng dẫn tích hợp SDK

## Tính năng

- mở webview tư vấn sức khỏe
- call native

## Yêu cầu: iOS 14.3+

> ⚠️ **Từ version 2.0.0**, SDK chỉ hỗ trợ **Swift Package Manager**. CocoaPods không còn được hỗ trợ do SendBirdCalls đã ngừng hỗ trợ CocoaPods từ version 1.11.0.

## SDK Integration

### Swift Package Manager (Khuyến nghị)

-
- Nhấn vào biểu tượng "+" tại mục `Farmeworks, Libraries, and Embedded Content`.
- Chọn Add Other...
- Chọn Add Package Dependency
- Nhập "https://github.com/e-doctorvn/dlvn-sdk-ios" vào ô tìm kiếm
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
| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| currentViewController | UIViewController? | UIViewController to display, if nil will use first view of rootViewController |
| urlString | String? | URL to open in WebView. If nil, use the initialized value in SDK |


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



| Parameter | Type          | Description                       |
| :-------- | :----------- | :-------------------------------- |
| data      | [String: Any] | Required|

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
- withURL == nil thì sẽ lấy url mặc định  (truyền url để xử lý  phần notification)
- data == nil thì sẽ ko login được
- onSdkRequestLogin: hàm này sẽ callback lại khi request login data là url

---
-- CALL NATIVE
-
## Yêu cầu: 
- iOS 14.3 trở lên
- Swift 5.0 trở lên
- Xcode 15.0 trở lên
## Cấu hình
- Bật "Voice over IP" trong Signing & Capabilities -> "Background Modes"
![N|Solid](https://firebasestorage.googleapis.com/v0/b/application-18caf.appspot.com/o/Screenshot%202023-12-13%20at%2010.25.15.png?alt=media&token=d69c0009-f0f3-4d4b-98eb-ab15db07dc0b)
- Thêm quyền Microphone và Camera:
    <key>NSCameraUsageDescription</key>
    <key>NSMicrophoneUsageDescription</key>

---
-- CHAT Notification
-
bật Remoote notification trong Background Modes
- Lúc login thành công gọi hàm : authenticateEDROC vs param là data chứa thông tin tài khoản đó
- Hàm handleRegistriNotification sẽ được gọi trong : application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) vs param là deviceToken 
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



