
//
//  AppDelegate.swift
//  Wow
//
//  Created by gakaki on 16/3/4.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
//import MonkeyKing
import IQKeyboardManagerSwift
import YYWebImage
import SwiftyUserDefaults


//import JSPatch
//import JSPatchHelper
//import wow_talkingData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var rootVC : UIViewController?
    //    var sideController:WOWSideContainerController!
    var adLaunchView: AdLaunchView?

    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        self.configRootVC()
        DLog("whats")
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        asyncLoad()

        IQKeyboardManager.sharedManager().enable = true
        initialAppearance()     //初始化外观
        registAppKey(launchOptions) //注册第三方
       
        appConfig()
        
        ADLaunchView()
        return true
    }
 
    func appConfig(){
    
        let cache_size      = UInt(50 * 1024 * 1024)
        YYWebImageManager.shared().cache?.memoryCache.costLimit     = cache_size
        ImageCache.default.maxDiskCacheSize                         = cache_size

    }
    func ADLaunchView(){
        self.fetchADImage()

        adLaunchView    = AdLaunchView(frame: UIScreen.main.bounds)
        adLaunchView?.delegate = self
        window?.addSubview(adLaunchView!)
        
    }
    
   
    
    func asyncLoad(){

        DispatchQueue.global(qos: .background).async {
            print("task" + "\(Thread.current)")
            CityDataManager.data
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        DLog("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

        DLog("applicationDidEnterBackground")

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

        DLog("applicationWillEnterForeground")

    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {

        DLog("applicationWillTerminate")

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UMSocialSnsService.applicationDidBecomeActive()
    }
    
    
    
    private func application(_ application: UIApplication,  userActivity: NSUserActivity,  restorationHandler: ([AnyObject]?) -> Void) -> Bool
    {
        TalkingDataAppCpa.onReceiveDeepLink(userActivity.webpageURL)

        //DeepShare
        if DeepShare.continue(userActivity) {
            return true
        }
        //Universal Link
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            //handle url
            
            let d = " get url is \(url) , url string is \(url.absoluteString)"
            DLog(d)
            
            WOWHud.showMsg(d)

            if url.host == "qnssl.com" {
                
            }else{
                UIApplication.shared.openURL(url)
            }
            return true
        }
        
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Pingpp.handleOpen(url, withCompletion: nil) {
            return true
        }
        
        
        //growing io
        if Growing.handle(url) {
            return true
        }
        
        //DeepShare
        if DeepShare.handle(url) {
            return true
        }
        
        //TalkingData ADTracking
        TalkingDataAppCpa.onReceiveDeepLink(url)
            
//        if MonkeyKing.handleOpenURL(url) {
//            return true
//        }
        if UMSocialSnsService.handleOpen(url) {
            return true
        }
        return true
    }
    
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        Pingpp.handleOpen(url, withCompletion: nil)
        UMSocialSnsService.handleOpen(url)
        
        //growing io
        if Growing.handle(url) {
            return true
        }
//
        //DeepShare
        if DeepShare.handle(url) {
            return true
        }
        
        //TalkingData ADTracking
        TalkingDataAppCpa.onReceiveDeepLink(url)
        return true
    }
    
  
}




//extension AppDelegate:DeepShareDelegate{
extension AppDelegate{
    func rootVCGuide(){
        let nav = UIStoryboard.initNavVC("Login", identifier:String(describing: WOWGuideController.self))
        nav.navigationController?.setNavigationBarHidden(true, animated: false)
        nav.isNavigationBarHidden = true
        window?.rootViewController =    nav
    }
    
   
    func configRootVC(){
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let introVC = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWIntroduceController.self))
            self.window?.rootViewController = introVC
            rootVCGuide()
            
        }else{
            
            let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
            AppDelegate.rootVC = mainVC
            window?.rootViewController = mainVC
            
        }
        

//
//        window?.rootViewController =  UIStoryboard.initNavVC("Found", identifier:)
//        window?.rootViewController =  UIStoryboard.initialViewController("Found")
////        
//        let storyboard      = UIStoryboard(name: "Found", bundle: nil)
//        let viewController  = storyboard.instantiateViewController(withIdentifier: String(describing: VCCategory.self)) as! VCCategory
//        window?.rootViewController = viewController
//          window?.rootViewController =  VCBuy(nibName: nil, bundle: nil)
//        let vc_designer_list = UIStoryboard.initialViewController("Designer", identifier:String(VCDesignerList)) as! VCDesignerList
//        window?.rootViewController =  vc_designer_list
//          window?.rootViewController = UINavigationController(rootViewController: VCCategoryChoose())
        
//        window?.rootViewController = UINavigationController(rootViewController: VCShopping())
        
//        window?.rootViewController =  VCCategoryProducts()
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = 49      //247到254是SKU 2 42
//        window?.rootViewController = vc
    }
    

    func onInappDataReturned(_ params: [AnyHashable: Any]!, withError error: NSError!) {
        
        if ((error == nil)) {
            DLog("finished init with params = \(params.description)");
            let name  = params["name"]
//            goToLinuxCmd(cmdName); //调用应用自己的接口跳转到分享时页面
        } else {
            DLog("init error id: \(error.code) error.toString()");
        }
    }
    
    func get_version_full() -> String{
        var v = "0.0.0"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let version_build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            v = "\(version).\(version_build)"
        }
        return v
    }
    func registAppKey(_ launchOptions: [AnyHashable: Any]?){
        //友盟

        MobClick.setAppVersion(self.get_version_full())
       
        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        UMSocialData.setAppKey(WOWID.UMeng.appID)
        UMSocialWechatHandler.setWXAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey, url:"http://www.wowdsgn.com/")
        
        WXApi.registerApp(WOWID.Wechat.appID)
    
        //Growing
        Growing.start(withAccountId: "a04e14656f08dc7e")
        //DeepShare
        DeepShare.initWithAppID("e494427d3e67f207", withLaunchOptions: launchOptions, withDelegate: self)
        //Talking Data
        TalkingData.sessionStarted("88C9035CD51E8009BE4441263D83003A", withChannelId: "app store")
        
        //Talking Data ADTracking
        TalkingDataAppCpa.init("e81f26ce70664a9dab698bae55be2044", withChannelId: "AppStore")
        
//        //MonkeyKing
//        MonkeyKing.registerAccount(.WeChat(appID: WOWID.Wechat.appID, appKey: WOWID.Wechat.appKey))
//        MonkeyKing.registerAccount(.Weibo(appID: WOWID.Weibo.appID, appKey: WOWID.Weibo.appKey, redirectURL: WOWID.Weibo.redirectURL))
        
        //LeanCloud
//        AVOSCloud.setApplicationId(WOWID.LeanCloud.appID, clientKey:WOWID.LeanCloud.appKey)
        
//        //融云IM
//        RCIM.sharedRCIM().initWithAppKey(WOWID.RongCloud.appID)
//        RCIM.sharedRCIM().connectWithToken(WOWID.RongCloud.testToken,success: { (userId) -> Void in
//            DLog("登陆成功。当前登录的用户ID：\(userId)")
//            }, error: { (status) -> Void in
//                DLog("登陆的错误码为:\(status.rawValue)")
//            }, tokenIncorrect: {
//                //token过期或者不正确。
//                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                DLog("token错误")
//        })
        
        //shareSDK

//        ShareSDK.registerApp(WOWID.ShareSDK.appKey,
//                             
//                             activePlatforms: [SSDKPlatformType.TypeWechat.rawValue,],
//                             onImport: {(platform : SSDKPlatformType) -> Void in
//                                
//                                switch platform{
//                                    
//                                case SSDKPlatformType.TypeWechat:
//                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                                    
//                                default:
//                                    break
//                                }
//            },
//                             onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//                                switch platform {
//                                    
//                                case SSDKPlatformType.TypeWechat:
//                                    //设置微信应用信息
//                                    appInfo.SSDKSetupWeChatByAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey)
//                                    
//                                default:
//                                    break
//                                    
//                                }
//        })

        
        
    }
    
    func initialAppearance(){
        window?.backgroundColor = UIColor.white
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([NSFontAttributeName:Fontlevel002], for: .normal)
        
        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white, size:CGSize(width: MGScreenWidth, height: 64)), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage.imageWithColor(MGRgb(234, g: 234, b: 234), size:CGSize(width: MGScreenWidth, height: 0.5)) //去除导航栏下方黑线
        
        //        navBar.shadowImage = UIImage()
        //更换导航栏返回按图片
        //        navBar.backIndicatorImage = UIImage(named: "nav_backArrow")
        //        navBar.backIndicatorTransitionMaskImage = UIImage(named:"nav_backArrow")
        
        //设置导航条背景
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black] //导航栏标题颜色
        navBar.tintColor = UIColor.black //导航栏元素颜色
        navBar.isTranslucent = false
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = MGRgb(20, g: 20, b: 20)
        tabBar.isTranslucent = false
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel3], for: .normal)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel1], for: .selected)
    }
    
}

//ADLaunchView 广告view
extension AppDelegate: AdLaunchViewDelegate {
    func adLaunchView(_ launchView: AdLaunchView, bannerImageDidClick imageURL: String) {
//        let urls = "http://www.desgard.com/"
//        if let url: URL = URL(string: urls) {
//            UIApplication.shared.openURL(url)
//        }
        
    }
    
    func fetchADImage(){
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AD, successClosure: { (result, code) in
            
            var r                     =  JSON(result)["startupImageList"]
            let res                   =  Mapper<WOWVOAd>().mapArray(JSONObject:r.arrayObject) ?? [WOWVOAd]()
            if let imgUrl = res.first?.imgUrl {
                Defaults[.pic_ad] = imgUrl
            }
        }) { (errorMsg) in
            
        }
        
    }
    
}
