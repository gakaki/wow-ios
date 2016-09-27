#source 'https://github.com/CocoaPods/Specs.git'

Pod::Spec.new do |s|
  s.name             = 'wow-model-network'
  s.version          = '0.1.0'
  s.summary          = 'wow-model-network'
  
  s.description      = <<-DESC
wowdsgn model
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow-model-network'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow-model-network.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files 	 = 'wow-model-network/Classes/**/*'
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.requires_arc = true

# model json
  s.dependency 'ObjectMapper', 			'~> 2.0.0'
  s.dependency 'SwiftyUserDefaults', 	'~> 3.0.0'
  s.dependency 'SwiftyJSON', 			'~> 3.0.0'
# network
  s.dependency 'Moya',                  '~> 8.0.0-beta.2'
  s.dependency 'RxSwift',               '~> 3.0.0-beta.1'
  s.dependency 'RxCocoa',               '~> 3.0.0-beta.1'
  # s.dependency 'Pitaya',                :git => 'https://github.com/johnlui/Pitaya.git'

end

