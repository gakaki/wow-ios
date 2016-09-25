platform :ios, '10.0'

target :wowapp do

	project 'wowapp.xcodeproj'

    inhibit_all_warnings!

	use_frameworks!


	pod 'BTNavigationDropdownMenu', git:"https://github.com/PhamBaTho/BTNavigationDropdownMenu.git",:branch => "swift-3.0"


	pod 'Alamofire', '~> 4.0'

	pod 'RxSwift', '3.0.0-beta.1'
	pod 'RxCocoa', '3.0.0-beta.1'
	pod 'RxDataSources', '~> 1.0.0-beta.2'

	pod 'SnapKit', '~> 3.0'
	pod 'UITableView+FDTemplateLayoutCell', '~> 1.5.beta'
	pod 'SDAutoLayout', '~> 2.1.6'
	pod 'SwiftyUserDefaults', '~> 3.0.0'
	pod 'Hashids-Swift' , git: "https://github.com/malczak/hashids.git" , :branch => 'master'

	pod 'Pitaya', git: "https://github.com/johnlui/Pitaya.git", :branch => 'swift3'
	pod 'Moya', git: "https://github.com/Moya/Moya.git", :branch => 'swift-3.0'
	pod 'Moya/RxSwift', git: "https://github.com/Moya/Moya.git", :branch => 'swift-3.0'
	pod 'EZSwiftExtensions', git: "https://github.com/goktugyil/EZSwiftExtensions.git", :branch => 'Swift3' #通用的拓展库
  
	pod 'JSPatch', git: "https://github.com/gakaki/JSPatch.git", :branch => 'master'
	pod 'JSPatch/Core', git: "https://github.com/gakaki/JSPatch.git", :branch => 'master'
	pod 'JSPatch/Extensions', git: "https://github.com/gakaki/JSPatch.git", :branch => 'master'
	pod 'JSPatch/Loader', git: "https://github.com/gakaki/JSPatch.git", :branch => 'master'
	pod 'JSPatchPlatform'
	
	pod 'SwiftyJSON', '~> 3.0.0'
	pod 'ObjectMapper',	 git: "https://github.com/Hearst-DD/ObjectMapper.git", :branch => 'swift-3'
	
	pod 'SVProgressHUD', '~> 2.0.2' #提示框
	pod 'YYWebImage'
	pod 'YYImage/WebP'
	pod 'YYImage'
	pod 'Kingfisher', '~> 3.0'
#	pod 'StyleKit'       		暂时不用
	pod 'UIColor_Hex_Swift', '~> 2.1'
	pod 'VTMagic'
#	pod 'Hashids-Swift'			#短id生成
	pod 'SDWebImage'

	
	pod "Qiniu",:path => "qiniu-sdk/Qiniu.podspec"	#七牛 sdk
	pod "FlexboxLayout",:path => "FlexBoxLayout/FlexboxLayout.podspec"
	pod "WowBase",:path => "WowBase/WowBase.podspec"

	pod 'UMengAnalytics-NO-IDFA' #无IDFA版SDK
	pod 'MJRefresh'
	pod 'DZNEmptyDataSet'
	pod 'IQKeyboardManagerSwift', '~> 4.0.6'
	#pod 'HidingNavigationBar', '~> 0.3.0'
	pod 'XZMRefresh'            #横向刷新
	pod 'FMDB'              
	pod 'FCUUID'

#Ping++支付
	pod 'Pingpp/Alipay',:path => "pingpp-ios/Pingpp.podspec"
	pod 'Pingpp/Wx',:path => "pingpp-ios/Pingpp.podspec"

	## ShareSDK主模块(必须)
	#pod 'ShareSDK3'
	## Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:可看此注意事项：http://bbs.mob.com/thread-20051-1-1.html
	#pod 'MOBFoundation'
	#
	## UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
	#pod 'ShareSDK3/ShareSDKUI'
	#
	## 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
	##pod 'ShareSDK3/ShareSDKPlatforms/QQ'
	#pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
	#pod 'ShareSDK3/ShareSDKPlatforms/WeChat'

#融云
#	pod 'RongCloudIMKit', '2.7.2' #融云用的realm 版本太低

#王云鹏自己的framework
	pod 'PonyFrameworkOnSwift',:path => "PonyFrameworkOnSwift/PonyFrameworkOnSwift.podspec"


#waitting For use
#列表空的占位图 TBEmptyDataSet
	#pod 'ActiveLabel'  @ #特殊的label
	#pod 'AFImageHelper'  Image的拓展
	#pod 'TagCellLayout', '~> 0.1'
	#pod 'ReactiveCocoa', '~> 4.0.4-alpha-4'
	#DOFavoriteButton 点赞动画
	#pod 'Format', '~> 0.2' 可格式化string,color的库
	#pod 'SwiftCop' 正则表达式的验证库
	#pod Timepiece Swift NSDate扩展库.
	#pod 'ReachabilitySwift' #网络监测
	#pod 'SwftWebViewProgress'  webview进度条
	#https://github.com/onmyway133/fantastic-ios-animation/blob/master/Animation/popup.md 动画集合，备用，可参考代码
	#http://cdn0.jianshu.io/p/83c069022e45/comments/802155 swift项目需要用到的开源组件

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end