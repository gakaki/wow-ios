
#workSpace
workspace ‘WowApp’

xcodeproj ‘WowFramework/WowFramework.xcodeproj'
xcodeproj ‘WowDsgn/WowDsgn.xcodeproj'


target :WowFramework do #FrameWork
platform :ios, ‘8.0’
pod 'Kingfisher','~>2.0.1'
use_frameworks!

xcodeproj ‘WowFramework/WowFramework.xcodeproj'
end

target :WowDsgn do #实例工程
platform :ios, ‘8.0’
use_frameworks!
pod 'SnapKit', '~> 0.19.1'
pod 'Moya', '~> 6.1.3'
pod 'SwiftyJSON', '~> 2.3.2'
pod 'Moya/RxSwift'
pod 'ObjectMapper', '~> 1.1.5'

pod 'RxSwift', '~> 2.2.0'
pod 'Kingfisher','~>2.0.1'
pod 'SVProgressHUD', '~> 2.0.2' #提示框


xcodeproj ‘WowDsgn/WowDsgn.xcodeproj'

end


#waitting For use
# 列表空的占位图 TBEmptyDataSet
# pod 'ActiveLabel'  @ #特殊的label
# pod 'AFImageHelper'  Image的拓展
#pod 'TagCellLayout', '~> 0.1'
#pod 'ReactiveCocoa', '~> 4.0.4-alpha-4'
#  http://cdn0.jianshu.io/p/83c069022e45/comments/802155 swift项目需要用到的开源组件
