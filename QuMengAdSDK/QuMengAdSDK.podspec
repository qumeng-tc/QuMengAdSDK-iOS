#
# Be sure to run `pod lib lint QuMengAdSDK-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                  = 'QuMengAdSDK'
  s.version               = '1.3.7'
  s.summary               = 'QuMengAdSDK-iOS.'
  s.description           = '趣盟平台'

  s.homepage              = 'https://github.com/qumeng-tc/QuMengAdSDK-iOS'

  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'chenxin02' => 'chenxin02@qutoutiao.net' }
  s.source                = { :git => "https://github.com/qumeng-tc/QuMengAdSDK-iOS.git" }

  s.frameworks            = 'UIKit', 'CoreLocation', 'SystemConfiguration', 'CoreGraphics', 'CoreMotion', 'CoreTelephony', 'AdSupport', 'QuartzCore', 'WebKit', 'MessageUI', 'SafariServices', 'AVFoundation', 'EventKit', 'CoreMedia', 'StoreKit'
#  s.libraries             = 'c++'
#  s.resource              = 'QMAdBundle.bundle'

  s.ios.deployment_target = '11.0'
  s.swift_version         = '5.1'
  s.platform              = :ios, "11.0"

  s.vendored_frameworks = 'QuMengAdSDK/QuMengAdSDK.xcframework'
  s.xcconfig = { 'ENABLE_BITCODE' => 'NO', 'OTHER_LDFLAGS' =>'-ObjC'}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
