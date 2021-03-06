
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
import EZSwiftExtensions
import WowShare


//import JSPatch
//import JSPatchHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,QYConversationManagerDelegate {
    
    var window: UIWindow?
    static var rootVC : UIViewController?
    let umessage  = AppDelegateUmengHelper()
    var lunchView: WOWLaunchView!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        self.configRootVC()
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        JLRouterRule.router_init()
        
        asyncLoad()
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true

        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        initialAppearance()     //初始化外观
        registAppKey(launchOptions) //注册第三方
       
        appConfig()
        
        QYSDK.shared().registerAppId("2d910b7e1775b42f797b28c701618660", appName: "尖叫设计")
        QYSDK.shared().conversationManager().setDelegate(self)
        let massageCount = QYSDK.shared().conversationManager().allUnreadCount()
        messageCountView(massageCount)
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(QYSessionViewController.classForCoder() as! UIViewController.Type)

        ADLaunchView()
        return true
    }
    
    func messageCountView(_ count: Int)  {
        if count == 0 {
            WOWCustormMessageView.dissMissView()
        }else {
            //如果未登录状态下，不显示
            guard WOWUserManager.loginStatus else {
                 WOWCustormMessageView.dissMissView()
                return
            }
            WOWCustormMessageView.show()
        }
    }

    // 检测是否有客服新消息
    func onUnreadCountChanged(_ count: Int) {
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
        messageCountView(count)
    }
    
    func appConfig(){
    
        let cache_size      = UInt(100 * 1024 * 1024)
        YYWebImageManager.shared().cache?.memoryCache.costLimit     = cache_size
        YYWebImageManager.shared().cache?.diskCache.costLimit       = cache_size
        ImageCache.default.maxDiskCacheSize                         = cache_size
        ImageCache.default.maxMemoryCost                            = cache_size
        URLCache.shared.diskCapacity                                = Int(cache_size)
        URLCache.shared.memoryCapacity                              = Int(cache_size)
        
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        //清除url的缓存
        URLCache.shared.removeAllCachedResponses()
    }
    
    func ADLaunchView(){
        
        lunchView = Bundle.main.loadNibNamed(String(describing: WOWLaunchView.self), owner: self, options: nil)?.last as! WOWLaunchView
        lunchView.frame =  CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight)
        window?.addSubview(lunchView)
        self.fetchADImage()
    }
    
    
    func asyncLoad(){

        DispatchQueue.global(qos: .background).async {
            DLog("task" + "\(Thread.current)")
            CityDataManager.data
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        UMessage.registerDeviceToken(deviceToken)
        QYSDK.shared().updateApnsToken(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        DLog("APNs device token: \(deviceTokenString)")
        WOWUserManager.deviceToken = deviceTokenString
       
        
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
//        UMSocialSnsService.applicationDidBecomeActive()
        
    }
    
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
  //universal link call back
        
        TalkingDataAppCpa.onReceiveDeepLink(userActivity.webpageURL)


        //Universal Link
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            //handle url
            
            let d = " get url is \(url) , url string is \(url.absoluteString)"
            DLog(d)

            if JLRouterRule.handle_open_url(url: url) {
                return true
            }
            
            
            
            return true
        }
        
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if JLRouterRule.handle_open_url(url: url){
            return true
        }

        if Pingpp.handleOpen(url, withCompletion: nil) {
            return true
        }

        //TalkingData ADTracking
        TalkingDataAppCpa.onReceiveDeepLink(url)
        
        if WowShare.handle_open_url(url) {
            return true
        }
        return true
    }
    
 
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        if JLRouterRule.handle_open_url(url: url){
            return true
        }

        
        if Pingpp.handleOpen(url, withCompletion: nil) {
            return true
        }
        if WowShare.handle_open_url(url) {
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
        if appVersion == nil {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
        
            rootVCGuide()
            
        }else{
            
            let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
            AppDelegate.rootVC = mainVC
            window?.rootViewController = mainVC
            
        }
        

    }
    
    func requestDeferreddeeplink() {
        WOWNetManager.sharedManager.requestWithTarget(.api_Deferreddeeplink, successClosure: { [weak self](result, code) in
            if self != nil {
                _ = JSON(result)
//                let orderCode = json["orderCode"].string
//                let payAmount = json["payAmount"].double
//                let paymentChannelName = json["paymentChannelName"].string
                
            }
            
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }

    }

    func onInappDataReturned(_ params: [AnyHashable: Any]!, withError error: NSError!) {
        
        if ((error == nil)) {
            DLog("finished init with params = \(params.description)");
            _  = params["name"]
//            goToLinuxCmd(cmdName); //调用应用自己的接口跳转到分享时页面
        } else {
            DLog("init error id: \(error.code) error.toString()");
        }
    }
    
      
    
    
    func get_version_full() -> String{
        var v = "0.0.0"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            v = version
        }
        return v
    }
    func registAppKey(_ launchOptions: [AnyHashable: Any]?){
        //"返回商户" 直接关闭支付页面
        Pingpp.ignoreResultUrl(true)
        //友盟 分析
        DLog(">> >>> 当前的友盟分析的版本是 " + MobClick.version().toString )
        MobClick.setAppVersion(self.get_version_full())
        MobClick.setLogEnabled(false)
        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
        UMAnalyticsConfig.sharedInstance().channelId = "App Store"
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        WowShare.manual_init()
        
        //友盟推送
        umessage.init_umessage(launchOptions)

        //Talking Data
        TalkingData.setExceptionReportEnabled(true)
        TalkingData.sessionStarted(WOWID.TalkingData.appKey, withChannelId: "AppStore")
        
        //Talking Data ADTracking
        TalkingDataAppCpa.init(WOWID.TalkingData.appID, withChannelId: "AppStore")

        
    }
    
    func initialAppearance(){
        window?.backgroundColor = UIColor.white
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([NSFontAttributeName:Fontlevel002], for: .normal)
        
        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white, size:CGSize(width: MGScreenWidth, height: 64)), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage.imageWithColor(MGRgb(234, g: 234, b: 234), size:CGSize(width: MGScreenWidth, height: 0.5)) //去除导航栏下方黑线

        
        //设置导航条背景
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black] //导航栏标题颜色
        navBar.tintColor = UIColor.black //导航栏元素颜色
        

    }
    //iOS10以下使用这个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        switch application.applicationState {
        case .active:
            break
        default:
            WOWUserManager.systemMsgCount = Calculate.increase(input: WOWUserManager.systemMsgCount)
            umessage.pushController(userInfo: userInfo)
            NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
        }
        
    }

}

//ADLaunchView 广告view
extension AppDelegate {
    
    func fetchADImage(){
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AD, successClosure: {[weak self] (result, code) in
            
            let r                     =  JSON(result)["startupImage"]
            let res                   =  Mapper<WOWCarouselBanners>().map(JSONObject:r.object)
            if let strongSelf = self {
                if let imgUrl = res?.bannerImgSrc {
                    strongSelf.lunchView.backgroundImg.yy_setImage(
                        with: URL(string:imgUrl.webp_url()),
                        placeholder: UIImage(named: "Artboard"),
                        options: [YYWebImageOptions.progressiveBlur , YYWebImageOptions.setImageWithFadeAnimation],
                        completion: {[weak self] (img, url, from_type, image_stage,err ) in
                            if let strongSelf = self {
                                UIView.animate(withDuration: 1, animations: {
                                    if strongSelf.lunchView.backgroundImg != nil {
                                        strongSelf.lunchView.backgroundImg.alpha = 1
                                    }
                                    
                                })
                            }
                            
                    })

                    strongSelf.lunchView.backgroundImg.addTapGesture(action: { (tap) in
                        if let res = res {
                            //设置主视图
                            let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
                            AppDelegate.rootVC = mainVC
                            strongSelf.window?.rootViewController = mainVC
                            strongSelf.lunchView.removeView()
                            VCRedirect.goToBannerTypeController(res)

                        }
                    })
                }
            }
            
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }
        
    }
    
}
