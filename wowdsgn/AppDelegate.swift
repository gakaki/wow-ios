
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

//import JSPatch
//import JSPatchHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var rootVC : UIViewController?
    //    var sideController:WOWSideContainerController!
    var adLaunchView: AdLaunchView?
    let umessage  = AppDelegateUmengHelper()
    var lunchView: WOWLaunchView!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        self.configRootVC()
        DLog("whats")
        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        RouterRule.router_init()

        
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
        
        lunchView = Bundle.main.loadNibNamed(String(describing: WOWLaunchView.self), owner: self, options: nil)?.last as! WOWLaunchView
        lunchView.frame =  CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight)
        window?.addSubview(lunchView)
//        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(closeButtonClick), userInfo: nil, repeats: false)
        self.fetchADImage()
    }
    
  
//    }
    
    func asyncLoad(){

        DispatchQueue.global(qos: .background).async {
            print("task" + "\(Thread.current)")
            CityDataManager.data
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
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
      
//            if url.host == "qnssl.com" {
//                
//            }else{
//                UIApplication.shared.openURL(url)
//            }
            return true
        }
        
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if RouterRule.handle_open_url(url: url){
            return true
        }
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
        
        if WowShare.handle_open_url(url) {
            return true
        }
        return true
    }
    
 
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        if RouterRule.handle_open_url(url: url){
            return true
        }
        
        if Pingpp.handleOpen(url, withCompletion: nil) {
            return true
        }
        if WowShare.handle_open_url(url) {
            return true
        }
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
        

//        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserCommentVC.self)) as! WOWUserCommentVC
////        vc.topic_id = 48      //247到254是SKU 2 42
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
        //友盟 分析
        MobClick.setAppVersion(self.get_version_full())
        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        WowShare.manual_init()
        
        //友盟推送
        umessage.init_umessage(launchOptions)

        
//        WXApi.registerApp(WOWID.Wechat.appID)
    
        //Growing
        Growing.start(withAccountId: "a04e14656f08dc7e")
        //DeepShare
        DeepShare.initWithAppID("e494427d3e67f207", withLaunchOptions: launchOptions, withDelegate: self)
        //Talking Data
        TalkingData.setExceptionReportEnabled(true)
        TalkingData.sessionStarted("12430AB8C707826E0C0FBDA290E620E4", withChannelId: "AppStore")
        
        //Talking Data ADTracking
        TalkingDataAppCpa.init("e81f26ce70664a9dab698bae55be2044", withChannelId: "AppStore")
        


        
        
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
            umessage.pushController(userInfo: userInfo)
            
        }
        
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
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AD, successClosure: {[weak self] (result, code) in
            
            var r                     =  JSON(result)["startupImageList"]
            let res                   =  Mapper<WOWVOAd>().mapArray(JSONObject:r.arrayObject) ?? [WOWVOAd]()
            if let strongSelf = self {
                if let imgUrl = res.first?.imgUrl {
                    //                Defaults[.pic_ad] = imgUrl
                    strongSelf.lunchView.backgroundImg.kf.setImage(with: URL(string:imgUrl),
                                        placeholder:UIImage(named: "Artboard"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: {[weak self] (image, error, chcheTypr, imageUrl) in
                                            if let strongSelf = self {
                                                UIView.animate(withDuration: 1, animations: {
                                                    if strongSelf.lunchView.backgroundImg != nil {
                                                        strongSelf.lunchView.backgroundImg.alpha = 1
                                                    }
                                                    
                                                })
                                            }
                    })
                    
                }
            }
            
        }) { (errorMsg) in
            
        }
        
    }
    
}
