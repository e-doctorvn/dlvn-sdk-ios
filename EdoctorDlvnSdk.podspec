Pod::Spec.new do |spec|
spec.name = "EdoctorDlvnSdk"
spec.version = "2.0.0"
spec.summary = "SDK tích hợp vào DlVN - ⚠️ DEPRECATED: Vui lòng sử dụng Swift Package Manager"
spec.description = "SDK được phát triển bởi EDoctor"
spec.homepage = "https://edoctor.io/"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.author = { "edoctor" => "edoctor.io" }
spec.platform = :ios, "14.0"
spec.swift_version = '5.0'
spec.dependencies = {
    # SendBirdCalls không còn hỗ trợ CocoaPods từ version 1.11.0
    # Vui lòng migrate sang Swift Package Manager
    "SendbirdChatSDK": ["~> 4.34.1"],
  }
spec.source = { :git => "https://github.com/e-doctorvn/dlvn-sdk-ios.git", :tag => 'v2.0.0' }
spec.source_files = [
    "Sources/EdoctorDlvnSdk/*.{swift}",
    "Sources/EdoctorDlvnSdk/*/*.{swift}",
    "Sources/EdoctorDlvnSdk/*/*/*.{swift}"
  ]
spec.resources = "Sources/EdoctorDlvnSdk/*.xcassets"
spec.readme = "https://github.com/e-doctorvn/dlvn-sdk-ios/blob/v2.0.0/README.md"
end
