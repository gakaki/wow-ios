

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

  s.ios.deployment_target = '8.0'
  s.source_files = 'wow3rd/Classes/**/*','wow3rd/libs/**/*.h'

  # s.resource_bundles = {
  #   'wow3rd' => ['wow3rd/Assets/*.png']
  # }
  s.framework             = 'UserNotifications'
  s.library               = 'z'

  s.public_header_files   = 'wow3rd/libs/**/*.h'
  s.vendored_libraries    = 'wow3rd/libs/**/*.a'
  # s.vendored_frameworks   = 'wow3rd/libs/**/*.framework'

  s.dependency 'URLNavigator', '~> 1.0'
#  s.dependency 'WebViewJavascriptBridge', '~> 5.0'
#  s.dependency 'SwiftWebViewBridge', '~> 0.2.0'
  s.dependency 'WebViewBridge.Swift'
  


  # s.frameworks = 'UIKit', 'MapKit'
end
