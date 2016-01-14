#
#  Be sure to run `pod spec lint CYPhotoPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CYPhotoPicker"
  s.version      = “0.8”
  s.summary      = "CYPhotoPicker include ALAsset & PHPhoto”
  s.description  = <<-DESC
			A Tool to use ALAsset or PHPhoto
                   DESC

  s.homepage     = "https://github.com/Sasistx/CYPhotoPicker"
  s.license      = "MIT (example)"
  s.author             = { "gaotianxiang" => "gaotianxiang@chunyu.me" }
  s.platform     = :ios, “6.0”

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/Sasistx/CYPhotoPicker.git", :tag => “1.0” }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resources = "Resource/*.png"
  s.dependency "SVProgressHUD", "~> 1.1"

end
