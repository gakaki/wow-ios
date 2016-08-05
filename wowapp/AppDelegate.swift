//
//  AppDelegate.swift
//  Wow
//
//  Created by gakaki on 16/3/4.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import MonkeyKing
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var rootVC : UIViewController?
    //    var sideController:WOWSideContainerController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        IQKeyboardManager.sharedManager().enable = true
        //初始化外观
        //com.wowdsgn.Wow
        initialAppearance()
        
        /**
         注册第三方
         */
        registAppKey()
        
        configRootVC()
    
        /**
         拉取配置数据
         */
        //requestConfigData()

        window?.makeKeyAndVisible()
        return true
    }
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UMSocialSnsService.applicationDidBecomeActive()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if Pingpp.handleOpenURL(url, withCompletion: nil) {
            return true
        }
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        if UMSocialSnsService.handleOpenURL(url) {
            return true
        }
        return true
    }
    
    // iOS 9 以上请用这个
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        Pingpp.handleOpenURL(url, withCompletion: nil)
        UMSocialSnsService.handleOpenURL(url)
        return true
    }
    
    
    
}




extension AppDelegate{
    
    func rootVCGuide(){
        let nav = UIStoryboard.initNavVC("Login", identifier:String(WOWGuideController))
        nav.navigationController?.setNavigationBarHidden(true, animated: false)
        nav.navigationBarHidden = true
        window?.rootViewController =    nav
    }
    
    func requestConfigData(){
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category, successClosure: { (result) in
            //            let cateArr = JSON(result)["category"].arrayObject
            //            if let cats = cateArr{
            //                for item in cats{
            //
            //                }
            //            }
            /*
             let cateArr = Mapper<WOWCategoryModel>().mapArray(result["category"])
             if let categorys = cateArr{
             for cate in categorys{
             try! WOWRealm.write({
             WOWRealm.add(cate, update: true)
             })
             }
             }*/
            
            let productTypeArr = Mapper<WOWProductStyleModel>().mapArray(result["product_style"])
            if let typeArr = productTypeArr{
                let ret = WOWRealm.objects(WOWProductStyleModel)
                try! WOWRealm.write({
                    WOWRealm.delete(ret)
                })
                for type in typeArr{
                    try! WOWRealm.write({
                        WOWRealm.add(type)
                    })
                }
            }
            //            NSNotificationCenter.postNotificationNameOnMainThread(WOWCategoryUpdateNotificationKey, object: nil)
        }) { (errorMsg) in
            
        }
    }
    
   
    func configRootVC(){
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        // 取出之前保存的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let introVC = UIStoryboard.initialViewController("Login", identifier:String(WOWIntroduceController))
            self.window?.rootViewController = introVC
            
        }else{
            
            let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
            AppDelegate.rootVC = mainVC
            window?.rootViewController = mainVC
            
        }
        

        rootVCGuide()
        //        ###MARK
//        window?.rootViewController =  UIStoryboard.initNavVC("Found", identifier:String(VCCategory))
//        window?.rootViewController =  UIStoryboard.initNavVC("Found", identifier:String(VCFound))

    }
    
    func registAppKey(){
        //友盟
        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        UMSocialData.setAppKey(WOWID.UMeng.appID)
        UMSocialWechatHandler.setWXAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey, url:"http://www.wowdsgn.com/")
        
        
        //MonkeyKing
        MonkeyKing.registerAccount(.WeChat(appID: WOWID.Wechat.appID, appKey: WOWID.Wechat.appKey))
        MonkeyKing.registerAccount(.Weibo(appID: WOWID.Weibo.appID, appKey: WOWID.Weibo.appKey, redirectURL: WOWID.Weibo.redirectURL))
        
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

        ShareSDK.registerApp(WOWID.ShareSDK.appKey,
                             
                             activePlatforms: [SSDKPlatformType.TypeWechat.rawValue,],
                             onImport: {(platform : SSDKPlatformType) -> Void in
                                
                                switch platform{
                                    
                                case SSDKPlatformType.TypeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                    
                                default:
                                    break
                                }
            },
                             onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                                switch platform {
                                    
                                case SSDKPlatformType.TypeWechat:
                                    //设置微信应用信息
                                    appInfo.SSDKSetupWeChatByAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey)
                                    
                                default:
                                    break
                                    
                                }
        })

        
        
    }
    
    func initialAppearance(){
        window?.backgroundColor = UIColor.whiteColor()
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([NSFontAttributeName:Fontlevel002], forState: .Normal)
        
        let navBar = UINavigationBar.appearance()
        navBar.translucent = false
        navBar.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor(), size:CGSizeMake(MGScreenWidth, 64)), forBarPosition: .Any, barMetrics: .Default)
        navBar.shadowImage = UIImage.imageWithColor(MGRgb(234, g: 234, b: 234), size:CGSizeMake(MGScreenWidth, 0.5)) //去除导航栏下方黑线
        
        //        navBar.shadowImage = UIImage()
        //更换导航栏返回按图片
        //        navBar.backIndicatorImage = UIImage(named: "nav_backArrow")
        //        navBar.backIndicatorTransitionMaskImage = UIImage(named:"nav_backArrow")
        
        //设置导航条背景
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()] //导航栏标题颜色
        navBar.tintColor = UIColor.blackColor() //导航栏元素颜色
        navBar.translucent = false
        
        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = MGRgb(20, g: 20, b: 20)
        tabBar.translucent = false
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel3], forState: .Normal)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel1], forState: .Selected)
    }
}
