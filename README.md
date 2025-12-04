# EdoctorDlvnSdk

SDK tích hợp tư vấn sức khỏe cho ứng dụng Dai-ichi Life Vietnam.

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.3+-blue.svg)](https://developer.apple.com/ios/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Tính năng

- Mở WebView tư vấn sức khỏe
- Video call với bác sĩ
- Chat và nhận thông báo

## Yêu cầu hệ thống

| Yêu cầu | Phiên bản |
|---------|-----------|
| iOS | 14.3+ |
| Swift | 5.0+ |
| Xcode | 15.0+ |

> **Lưu ý:** Từ version 2.0.0, SDK chỉ hỗ trợ **Swift Package Manager**. CocoaPods không còn được hỗ trợ do SendBirdCalls đã ngừng hỗ trợ CocoaPods từ version 1.11.0.

---

## Cài đặt

### Swift Package Manager

1. Trong Xcode, vào **File > Add Package Dependencies...**
2. Nhập URL repository:
   ```
   https://github.com/e-doctorvn/dlvn-sdk-ios
   ```
3. Chọn version và nhấn **Add Package**

> **Lưu ý:** Bạn cần có quyền truy cập vào repository. Tham khảo [hướng dẫn tạo Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens).

---

## Sử dụng

### Import SDK

```swift
import EdoctorDlvnSdk
```

### 1. Gửi dữ liệu xác thực

```swift
let data: [String: Any] = [
    "company": "",
    "partner_code": "",
    "partnerid": "your_partner_id",
    "deviceid": "your_device_id",
    "dcId": "your_dc_id",
    "token": "your_token"
]

DLVNSendData(data: data) { success, error in
    if success {
        print("Xác thực thành công")
    } else {
        print("Lỗi: \(error?.localizedDescription ?? "Unknown")")
    }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `data` | `[String: Any]` | Dữ liệu xác thực (bắt buộc) |

### 2. Mở WebView tư vấn

```swift
openWebView(currentViewController: self)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `currentViewController` | `UIViewController?` | ViewController hiển thị. Nếu `nil`, sử dụng rootViewController |
| `urlString` | `String?` | URL tùy chỉnh. Nếu `nil`, sử dụng URL mặc định |

### 3. Các hàm tiện ích

```swift
// Xóa cache WebView
clearWebViewCache()

// Chuyển đổi môi trường
changeEnv(envUpdate: .LIVE)     // Production
changeEnv(envUpdate: .SANDBOX)  // Development
```

---

## Tích hợp Video Call

### Cấu hình Xcode

1. **Background Modes** - Bật các options sau trong **Signing & Capabilities**:
   - Voice over IP
   - Remote notifications

2. **Info.plist** - Thêm các quyền:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Ứng dụng cần quyền Camera để thực hiện video call</string>
   
   <key>NSMicrophoneUsageDescription</key>
   <string>Ứng dụng cần quyền Microphone để thực hiện cuộc gọi</string>
   ```

### Xác thực Sendbird

```swift
// Khi user đăng nhập thành công
authenticateEDR(data: userData) { success, error in
    if success {
        print("Đăng nhập Sendbird thành công")
    }
}

// Khi user đăng xuất
deauthenticateEDR()
```

---

## Tích hợp Push Notification

### 1. Đăng ký device token

```swift
func application(_ application: UIApplication, 
                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    handleRegistriNotification(deviceToken: deviceToken)
}
```

### 2. Xử lý notification khi app đang mở

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            willPresent notification: UNNotification,
                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if isEdrMessage(notification: notification) && 
       allowPushNotificationBackground(notification: notification) {
        completionHandler([.banner, .sound, .badge])
    } else {
        // App xử lý notification khác
    }
}
```

### 3. Xử lý khi user tap vào notification

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
    handlePressNotificatin(response: response)
    completionHandler()
}
```

---

## Objective-C Support

```objc
@import EdoctorDlvnSdk;

// Khởi tạo SDK
DlvnSdk *dlvn = [[DlvnSdk alloc] init];

// Gửi dữ liệu xác thực
NSDictionary *data = @{
    @"partnerid": @"your_partner_id",
    @"deviceid": @"your_device_id",
    @"dcId": @"your_dc_id",
    @"token": @"your_token"
};

[dlvn DLVNSendDataOC:data completion:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"Success");
    }
}];

// Mở WebView
[dlvn openWebViewOCWithCurrentViewController:self 
                                     withURL:nil 
                                        data:data 
                           onSdkRequestLogin:^(NSString *urlString) {
    // Handle login request
}];
```

---

## License

MIT License - Copyright (c) 2024 EDoctor



