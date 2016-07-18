target :wowapp do #实例工程

inhibit_all_warnings!
platform :ios, '8.0'
use_frameworks!

pod 'SnapKit', '~> 0.19.1'
pod 'Moya', '~> 6.1.3'
pod 'RxSwift', '~> 2.2.0'
pod 'SwiftyJSON'
pod 'ObjectMapper'
pod 'Kingfisher','~>2.0.1'
pod 'SVProgressHUD', '~> 2.0.2' #提示框
pod 'MonkeyKing', '~> 0.9.2'

pod 'UMengAnalytics-NO-IDFA' #无IDFA版SDK
pod 'MJRefresh'
pod 'DZNEmptyDataSet'
pod 'EZSwiftExtensions', '~> 1.2.3' #通用的拓展库
pod 'HidingNavigationBar', '~> 0.3.0'
pod 'YYImage'

#Ping++支付
pod 'Pingpp/Alipay',:path => "pingpp-ios/Pingpp.podspec"
pod 'Pingpp/Wx',:path => "pingpp-ios/Pingpp.podspec"

#LeanCloud
pod 'AVOSCloud'               # 数据存储、短信、云引target :wowapp do #实例工程

# ShareSDK主模块(必须)
pod 'ShareSDK3'
# Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:可看此注意事项：http://bbs.mob.com/thread-20051-1-1.html
pod 'MOBFoundation'

# UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
pod 'ShareSDK3/ShareSDKUI'

# 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
#pod 'ShareSDK3/ShareSDKPlatforms/QQ'
pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
pod 'ShareSDK3/ShareSDKPlatforms/WeChat'




#LeanCloud
pod 'AVOSCloud'               # 数据存储、短信、云引擎调用等基础服务模块

pod 'JSONCodable', '~> 2.1'


#融云
pod 'RongCloudIMKit', '2.6.0'

#王云鹏自己的framework
# pod 'PonyFrameworkOnSwift',:git => 'https://github.com/MakeBetterMe/PonyFrameworkOnSwift.git'
pod 'PonyFrameworkOnSwift',:path => "PonyFrameworkOnSwift/PonyFrameworkOnSwift.podspec"
pod 'WowWebService',:path => "./WowWebService/WowWebService.podspec"
pod 'WowUI',:path => "./WowUI/WowUI.podspec"


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