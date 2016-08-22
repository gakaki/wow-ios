Pod::Spec.new do |s|
  s.name             = 'WowBase'
  s.version          = '0.1.0'
  s.summary          = 'A short description of WowBase.'

  s.description      = <<-DESC
wowdsgn base library
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/WowBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/WowBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WowBase/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WowBase' => ['WowBase/Assets/*.png']
  # }
  
  s.ios.vendored_frameworks = 'WowBase/WowBase.framework'
  s.ios.vendored_library = 'WowBase/WowBase.a'
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
