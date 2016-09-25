

Pod::Spec.new do |s|
  s.name             = 'FlexboxLayout'
  s.version          = '0.1.0'
  s.summary          = 'FlexboxLayout for swift'


  s.description      = <<-DESC
swift version flexboxlayout
                       DESC

  s.homepage         = 'https://github.com/gakaki/FlexboxLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/FlexboxLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FlexboxLayout/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FlexboxLayout' => ['FlexboxLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
