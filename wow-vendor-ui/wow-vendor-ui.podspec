

Pod::Spec.new do |s|

  s.name             = 'wow-vendor-ui'
  s.version          = '0.1.0'
  s.summary          = 'A short description of wow-vendor-ui.'

  s.description      = <<-DESC
		wow vendo ui
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow-vendor-ui'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow-vendor-ui.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'wow-vendor-ui/Classes/**/*'

  # s.resource_bundles = {
  #   'wow-vendor-ui' => ['wow-vendor-ui/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher'
	s.dependency 'EZSwiftExtensions'

end
