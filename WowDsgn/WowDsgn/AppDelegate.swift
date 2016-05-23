//
//  AppDelegate.swift
//  Wow
//
//  Created by gakaki on 16/3/4.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var rootVC : UIViewController?
//    var sideController:WOWSideContainerController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
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
//        requestConfigData()
        
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
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        UMSocialSnsService.handleOpenURL(url)
        Pingpp.handleOpenURL(url, withCompletion: nil)
        return true
    }
    
    // iOS 9 以上请用这个
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        Pingpp.handleOpenURL(url, withCompletion: nil)
        return true
    }
    
}


extension AppDelegate{
    
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
    }
    
    func registAppKey(){
        UMAnalyticsConfig.sharedInstance().appKey = WOWUMKey
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        UMSocialData.setAppKey(WOWUMKey)
        UMSocialWechatHandler.setWXAppId(WOWWXID, appSecret: WOWWXAppSecret, url:"http://www.wowdsgn.com/")
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToWechatSession,UMShareToWechatTimeline])
        
        //LeanCloud
        AVOSCloud.setApplicationId(WOWLeanCloudID, clientKey: WOWLeanCloudKey)
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
        tabBar.translucent = false
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel3], forState: .Normal)
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GrayColorlevel1], forState: .Selected)
    }
}
