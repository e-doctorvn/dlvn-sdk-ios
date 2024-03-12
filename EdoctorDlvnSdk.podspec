Pod::Spec.new do |spec|
spec.name = "EdoctorDlvnSdk"
spec.version = "1.2.0"
spec.summary = "SDK tích hợp vào DlVN"
spec.description = "SDK được phát triển bởi EDoctor"
spec.homepage = "https://edoctor.io/"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.author = { "edoctor" => "edoctor.io" }
spec.platform = :ios, "11.0"
spec.swift_version = '5.0'
spec.dependencies = {
    "SendBirdCalls": ["~> 1.10.13"],
    "SendbirdChatSDK": ["~> 4.15.1"]
  }
spec.source = { :git => "https://github.com/e-doctorvn/dlvn-sdk-ios.git", :tag => 'v1.2.0' }
spec.source_files = [
    "Sources/EdoctorDlvnSdk/*.{swift}",
    "Sources/EdoctorDlvnSdk/*/*.{swift}",
    "Sources/EdoctorDlvnSdk/*/*/*.{swift}"
  ]
spec.resources = "Sources/EdoctorDlvnSdk/*.xcassets"
spec.readme = "https://github.com/e-doctorvn/dlvn-sdk-ios/blob/v1.2.0/README.md"
end
