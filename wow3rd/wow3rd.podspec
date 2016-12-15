

Pod::Spec.new do |s|
  s.name             = 'wow3rd'
  s.version          = '0.1.0'
  s.summary          = 'wow3rd 第三方'

  s.description      = <<-DESC
wowdsgn集成各种第三方库
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow3rd'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow3rd.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.public_header_files   =                       'wow3rd/libs/**/*.h','wow3rd/frameworks/**/*.h'
  s.source_files          = 'wow3rd/Classes/**/*','wow3rd/libs/**/*.h','wow3rd/frameworks/**/*.h'
  s.frameworks            = 'UIKit','CoreTelephony','SystemConfiguration','ImageIO','CoreData'
  s.weak_framework        = 'UserNotifications'
  s.library               = 'z','c++','sqlite3'

  s.vendored_libraries    = 'wow3rd/libs/**/*.a'
  s.vendored_frameworks   = 'wow3rd/frameworks/**/*.framework'

  s.xcconfig              = {
    # 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
    'OTHER_LDFLAGS' => '-ObjC -all_load -force_load'
  }


  s.dependency 'URLNavigator', '~> 1.0'
#  s.dependency 'WebViewJavascriptBridge', '~> 5.0'
#  s.dependency 'SwiftWebViewBridge', '~> 0.2.0'
  s.dependency 'WebViewBridge.Swift'
#  s.dependency 'Pingpp','~> 2.2.10'

#  s.dependency 'UMengUShare/UI'    # U-Share SDK UI模块（分享面板，建议添加）
#  s.dependency 'UMengUShare/Social/Sina'    # 集成新浪微博


end
