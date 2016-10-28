#
#  Be sure to run `pod spec lint CYPhotoPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CYPhotoPicker"
  s.version      = "1.3.2"
  s.summary      = "CYPhotoPicker include ALAsset & PHPhoto"
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/Sasistx/CYPhotoPicker"
  s.license      = "MIT (example)"
  s.author             = { "gaotianxiang" => "gaotianxiang@chunyu.me" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/Sasistx/CYPhotoPicker.git", :tag => s.version }
  s.source_files  = "CYPhotoPicker/Classes/**/*.{h,m}"
  s.resources = "CYPhotoPicker/Resource/*.png"
  s.weak_framework = 'Photos'
  s.license      = "MIT"
  s.description  = "CYPhotoPicker include ALAsset & PHPhoto"


end
