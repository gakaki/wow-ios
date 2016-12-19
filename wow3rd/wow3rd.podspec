
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

    s.public_header_files   =                       'wow3rd/lib_frameworks/**/*.h'
    s.source_files          = 'wow3rd/Classes/**/*','wow3rd/lib_frameworks/**/*.h'
    s.frameworks            = 'CFNetwork','QuartzCore','CoreMotion','UIKit','CoreTelephony','SystemConfiguration','ImageIO','CoreData','Security','AdSupport','Foundation','CoreLocation'
    #'PassKit'
  #   'AddressBook.framework','AddressBookUI','AudioToolbox','CoreAudio','CoreGraphics','ImageIO','MapKit','MessageUI','MobileCoreServices'



    s.weak_framework        = 'UserNotifications'
    s.library               = 'z','c++','sqlite3','icucore','stdc++'

    s.vendored_libraries    = 'wow3rd/lib_frameworks/**/*.a'
    s.vendored_frameworks   = 'wow3rd/lib_frameworks/**/*.framework'

    s.xcconfig              = {
      # 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
      'OTHER_LDFLAGS' => '-ObjC -all_load -force_load'
    }

    s.dependency 'URLNavigator', '~> 1.0'
    s.dependency 'WebViewBridge.Swift'
    s.dependency 'LeanCloud'


  #  s.dependency 'WebViewJavascriptBridge', '~> 5.0'
  #  s.dependency 'SwiftWebViewBridge', '~> 0.2.0'



  end
