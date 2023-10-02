Pod::Spec.new do |spec|
spec.name = "EdoctorDlvnSdk"
spec.version = "1.0.6"
spec.summary = "SDK tích hợp vào dlvn"
spec.description = "SDk được phát triển bởi edoctor"
spec.homepage = "https://edoctor.io/"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.author = { "edoctor" => "edoctor.io" }
spec.platform = :ios, "13.0"
spec.swift_version = '5.0'
spec.source = { :git => "https://github.com/e-doctorvn/dlvn-sdk-ios.git", :tag => 'v1.0.6' }
spec.source_files = "Sources/EdoctorDlvnSdk/*.{swift}"
spec.readme = "https://github.com/e-doctorvn/dlvn-sdk-ios/blob/v1.0.6/README.md"
end
