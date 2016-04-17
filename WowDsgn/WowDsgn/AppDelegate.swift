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
    var sideController:WOWSideContainerController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        //初始化外观
        //com.wowdsgn.Wow
        initialAppearance()
//        registAppKey()
        configRootVC()
        
        /**
         拉取配置数据
         */
        //FIXME:要看下loading的加载效果咯
        requestConfigData()
        
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
    
}


extension AppDelegate{
    
    func requestConfigData(){
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category, successClosure: { (result) in
            let cateArr = Mapper<WOWCategoryModel>().mapArray(result)
            if let categorys = cateArr{
                for cate in categorys{
                    try! WOWRealm.write({ 
                         WOWRealm.add(cate, update: true)
                    })
                }
            }
            NSNotificationCenter.postNotificationNameOnMainThread(WOWCategoryUpdateNotificationKey, object: nil)
        }) { (errorMsg) in
            
        }
    }
    
    func configRootVC(){
        let sideVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(WOWLeftSideController))
        let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
        sideController = WOWSideContainerController(sideViewController:sideVC, mainViewController:mainVC)
        window?.rootViewController = sideController
    }
    
//    func registAppKey(){
//        UMSocialData.setAppKey(UMKey)
//    }
    
    func initialAppearance(){
        window?.backgroundColor = UIColor.whiteColor()
        let navBar = UINavigationBar.appearance()
        navBar.translucent = false
        navBar.shadowImage = UIImage.imageWithColor(ThemeColor, size:CGSizeMake(MGScreenWidth, 1)) //去除导航栏下方黑线
        //更换导航栏返回按图片
        navBar.backIndicatorImage = UIImage(named: "nav_backArrow")
        navBar.backIndicatorTransitionMaskImage = UIImage(named:"nav_backArrow")
        
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([NSFontAttributeName:Fontlevel002], forState: .Normal)
        
        
        
        //设置导航条背景
        navBar.setBackgroundImage(UIImage(named: "Bar"), forBarPosition: .Any, barMetrics: .Default)
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
