# DlvnSdk
## Hướng dẫn tích hợp sdk

## Tính năng

- mở webview tư vấn sức khỏe
- Demo function

## Yêu cầu: .iOS(.v13)

## SDK Integration
-- Đảm bảo bạn đã được thêm tài khoản vào repo  này
-- Hướng dẫn lấy access Token tại đây : https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

-- Dưới đây là 2 cách để tích hợp sdk vào dự án

-- Cách 1 dùng Cocoapod:
-
- Thêm đoạn mã vào podfile dự án :
    ```swift
    target 'MyApp' do
      pod 'DlvnSdk', '~> 1.0' 
    end
    ```
- sau đó chạy lệnh "pod install" để cài đặt
- Nhập username
- Nhập password là access token đã tạo ở bước trên  (không phải nhập password git)
* lưu ý: Nếu dùng cách này thì phải mở file  .xcworkspace 

-- Cách 2 Packafe Dependency:
-
- Nhấn vào biểu tượng "+" tại mục `Farmeworks, Libraries, and Embedded Content`.
- Chọn Add Other...
- Chọn Add Package Dependency
- Nhập "https://github.com/kidfire/dlvn-sdk-ios" vào ô tìm kiếm
- Nhập userName và access token được tạo ở bước trên
- ![N|Solid](https://firebasestorage.googleapis.com/v0/b/application-18caf.appspot.com/o/Screenshot%202023-08-30%20at%2016.17.54.png?alt=media&token=1604d9b7-8c55-42db-9645-82260b5fa423)
- Nhấn Add Package

## Sử dụng

Import:

```swift
import DlvnSdk
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
let data: String = sampleFunc(data: "Data")
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| data      | string | Required|

