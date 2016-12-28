
Pod::Spec.new do |s|
  s.name             = 'WowThird'
  s.version          = '0.1.0'
  s.summary          = 'WowThird 第三方库'
  s.description      = <<-DESC
WowThird 第三方库 POD
                       DESC

  s.homepage         = 'https://github.com/gakaki/WowThird'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/WowThird.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WowThird/Classes/**/*'

  s.public_header_files   =                       'WowThird/lib_frameworks/**/*.h'
  s.source_files          = 'WowThird/Classes/**/*','WowThird/lib_frameworks/**/*.h'
  s.frameworks            = 'CFNetwork','QuartzCore','CoreMotion','UIKit','CoreTelephony','SystemConfiguration','ImageIO','CoreData','Security','AdSupport','Foundation','CoreLocation'
  #'PassKit'
#   'AddressBook.framework','AddressBookUI','AudioToolbox','CoreAudio','CoreGraphics','ImageIO','MapKit','MessageUI','MobileCoreServices'

  s.weak_framework        = 'UserNotifications'
  s.library               = 'z','c++','sqlite3','icucore','stdc++'

  s.vendored_libraries    = 'WowThird/lib_frameworks/**/*.a'
  s.vendored_frameworks   = 'WowThird/lib_frameworks/**/*.framework'

  s.xcconfig              = {
    # 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
    'OTHER_LDFLAGS' => '-ObjC -all_load -force_load'
  }

  s.dependency 'URLNavigator'
  s.dependency 'WebViewBridge.Swift'
  s.dependency 'LeanCloud'


#  s.dependency 'WebViewJavascriptBridge', '~> 5.0'
#  s.dependency 'SwiftWebViewBridge', '~> 0.2.0'
end
