
Pod::Spec.new do |s|
  s.name             = 'wow-ui'
  s.version          = '0.1.0'
  s.summary          = 'A short description of wow-ui.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow-ui'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow-ui.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'wow-ui/Classes/**/*.{h,m,swift}'

  # s.resource_bundles = {
  #   'wow-ui' => ['wow-ui/Assets/*.png']
  # }

  s.public_header_files = 'wow-ui/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'YYWebImage'
  s.dependency 'YYImage/WebP'
  s.dependency 'wow-util'
end
