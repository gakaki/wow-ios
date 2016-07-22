

Pod::Spec.new do |s|
  s.name             = 'QiniuTokenIOS'
  s.version          = '0.1.0'
  s.summary          = 'QiniuTokenIOS use ios generate token'


  s.description      = <<-DESC
qiniutoken local version
                       DESC

  s.homepage         = 'https://github.com/gakaki/QiniuTokenIOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/QiniuTokenIOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'QiniuTokenIOS/Classes/**/*'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'Qiniu' , "~> 7.1"
end
