
Pod::Spec.new do |s|
  s.name             = 'wow-util'
  s.version          = '0.1.0'
  s.summary          = 'A short description of wow-util.'

  s.description      = <<-DESC
WowUtil
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow-util'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow-util.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'wow-util/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
