Pod::Spec.new do |s|
  s.name             = 'wow-talkingData'
  s.version          = '0.1.0'
  s.summary          = 'talkingdata'


  s.description      = <<-DESC
talking datga
                       DESC

  s.homepage         = 'https://github.com/gakaki/wow-talkingData'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gakaki' => 'gakaki@gmail.com' }
  s.source           = { :git => 'https://github.com/gakaki/wow-talkingData.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'

  s.source_files    = 'wow-talkingData/Classes/**/*',"libs/*.h"
  
  s.frameworks      = 'UIKit', 'Security', 'CoreTelephony', 'AdSupport', 'SystemConfiguration'
  s.libraries       = 'z'
  #s.preserve_paths      = 'libs/TalkingDataAppCpa.a','libs/TalkingDataAppCpa.h'
 # s.public_header_files = 'libs/*.h'
  
  s.ios.vendored_libraries = 'libs/libTalkingDataAppCpa.a'
 # s.platform          = :ios, "9.0"            #支持的平台及版本，这里我们呢用swift，直接上9.0
  
  s.requires_arc       = true
 # s.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-lz -ObjC  -lTalkingDataAppCpa"}
 #s.module_name       = 'WowTalkingData'        #模块名称
  
end
