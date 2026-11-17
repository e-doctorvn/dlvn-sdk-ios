# Kế hoạch chuyển phân phối SDK eDoctor (`dlvn-sdk-ios`) từ CocoaPods sang SPM

Ngày lập: 17/11/2026 — phiên bản hiện tại: 1.3.5 (tag `v1.3.5`)

## Hiện trạng

- Repo đang phát hành **song song** cả hai kênh: `EdoctorDlvnSdk.podspec` và `Package.swift`. App Example đã dùng SPM qua local package (`../../dlvn-sdk-ios`).
- Hai kênh không dùng cùng phiên bản Sendbird Chat: SPM là **4.39.11**, CocoaPods là **4.39.10** (CocoaPods không có bản mới hơn).
- `CHANGELOG.md` đã thông báo từ trước: từ bản **2.0.0** chỉ hỗ trợ SPM.
- CocoaPods trunk theo lịch đã công bố chuyển sang chỉ đọc từ khoảng **02/12/2026**. Cần kiểm tra pod đang nằm trên trunk hay private spec repo.

## Các lỗi phải sửa trước khi chuyển hẳn

1. **Ảnh bị mất khi tích hợp bằng SPM (nghiêm trọng).** Code lấy ảnh qua `Bundle(for: WebViewController.self)` ở:
   - `Sources/EdoctorDlvnSdk/Widget/WidgetList.swift:33`, `:37`
   - `Sources/EdoctorDlvnSdk/Utils/BackgroundImage.swift:24`, `:36`
   - `Sources/EdoctorDlvnSdk/call/callLayout/VideoCallScreen.swift:140`

   Với SPM, SDK được link tĩnh nên lời gọi này trả về main bundle của app, trong khi `Media.xcassets` nằm trong `EdoctorDlvnSdk_EdoctorDlvnSdk.bundle`. Hậu quả: 4 ảnh `room`, `enterRoom`, `backgroundCall`, `chatImage` không hiển thị. (Suy luận từ cách SPM xử lý resource — cần build để xác nhận.)

   Cách sửa: thêm helper

   ```swift
   extension Bundle {
       static var sdk: Bundle {
           #if SWIFT_PACKAGE
           return .module
           #else
           return Bundle(for: WebViewController.self)
           #endif
       }
   }
   ```

   và khai báo rõ `resources: [.process("Media.xcassets")]` trong `Package.swift`.

2. `Sources/EdoctorDlvnSdk/call/extensionCall/CXCallManager.swift:230` gọi `UIImage(named: "icLogoSymbolInverse")` nhưng SDK không có ảnh này → phụ thuộc asset của app host. Quyết định: đưa ảnh vào SDK hoặc ghi rõ trong README.

3. **Chưa có `PrivacyInfo.xcprivacy`.** Apple yêu cầu với SDK; SDK dùng UserDefaults (API thuộc diện "required reason"). Thêm vào target SPM, và vào podspec trong giai đoạn còn hỗ trợ CocoaPods.

## Các giai đoạn

### Giai đoạn 1 — Phát hành 1.4.0: hỗ trợ cả hai kênh, ưu tiên SPM

- [x] Sửa 3 lỗi ở trên.
- [x] Thêm CI (GitHub Actions): `xcodebuild build test -scheme EdoctorDlvnSdk -destination 'platform=iOS Simulator,name=<device>'` (`swift build` không dùng được vì SDK cần UIKit).
- [x] Thêm workflow `release-check.yml`: khi push tag, tạo package trống resolve SDK từ tag trên GitHub và build (thay cho việc chuyển app Example sang tag remote).
- [x] Viết lại README: SPM là cách 1; hướng dẫn xác thực repo private (PAT trong Keychain của Xcode, `.netrc` cho CI); dùng `@import EdoctorDlvnSdk;` từ Objective-C.
- [x] Ghi thông báo deprecation CocoaPods vào CHANGELOG và `spec.description`.

### Giai đoạn 2 — Chuyển app DLVN đang tích hợp

- [ ] Gỡ `pod 'EdoctorDlvnSdk'`, thêm package `https://github.com/e-doctorvn/dlvn-sdk-ios` với rule "Up to Next Major" từ 1.4.0.
- [ ] **Rủi ro:** nếu app vẫn kéo Sendbird qua Pods trong khi SDK kéo Sendbird qua SPM → trùng symbol/class. Chuyển toàn bộ Sendbird sang SPM cùng lúc.
- [ ] Kiểm thử: mở WebView, đăng nhập bằng dữ liệu đã lưu, gọi video + CallKit/PushKit, ảnh ở widget và màn hình gọi.

### Giai đoạn 3 — Phát hành 2.0.0: chỉ còn SPM ✅

> **Hoàn thành 17/11/2026.** PR e-doctorvn/dlvn-sdk-ios#3 merge (`4cc5266`), tag `v2.0.0`, GitHub Release v2.0.0 (Latest). Workflow Release check cho 2.0.0 pass (resolve đúng tag, build thiết bị + simulator arm64).
>
> Phát hành **trước** khi xong giai đoạn 2 và trước khi kiểm thử trên máy thật, theo quyết định của team. App đang dùng không bị ảnh hưởng: CocoaPods dừng ở 1.4.0, SPM rule 1.x không tự lên 2.0.0.

- [x] Xoá `EdoctorDlvnSdk.podspec` và hướng dẫn CocoaPods trong README.
- [x] Nâng iOS tối thiểu lên 14.0 và SendBirdCalls lên 1.12.3 trong 2.0.0 (đã đánh giá: không đổi API, test pass; mất simulator x86_64; cần kiểm thử trên máy thật CallKit/PushKit, video, gọi người đang bận).
- [x] Merge, gắn tag `v2.0.0`, tạo GitHub Release.
- [x] Sửa workflow Release check build thiết bị + simulator arm64 (e-doctorvn/dlvn-sdk-ios#9).
- [ ] Còn lại: kiểm thử trên máy thật với SendBirdCalls 1.12.3 — CallKit/PushKit (app tắt, nền, khoá màn hình), đăng ký VoIP token, gọi người đang bận, chất lượng video, kết nối lại khi mạng yếu.

### Giai đoạn 4 — Dọn dẹp

- [x] Xoá package `API/` (Apollo), không được tham chiếu.
- [x] Thêm `.gitignore`, gỡ `.DS_Store`, `xcuserdata`, `.swiftpm/` khỏi git.

## Bảo mật

Remote `origin` của repo đang chứa GitHub token dạng plaintext trong URL. Cần revoke token trên GitHub, đặt lại remote không kèm token:

```bash
git remote set-url origin https://github.com/e-doctorvn/dlvn-sdk-ios.git
```

Sau đó xác thực qua Keychain hoặc `gh auth`.
