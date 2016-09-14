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
//import JSPatch
import XHLaunchAd

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
//        let webpSupport = YYImageWebPAvailable()
        /**
         注册第三方
         */
        registAppKey(launchOptions)

        
        let useAd = false
        if useAd == true {
            self.startAD()
        }else{
            self.configRootVC()
        }
       
        
        asyncLoad()

        
        window?.makeKeyAndVisible()
        
        
//        JSPatchHelper.jspatch_playground()
//        JSPatchHelper.jspatch_init()
        
        
        //显示启动
        
        return true
    }
 
    
    var is_started_root_vc = false
    
    func startAD(){
        
        //请求网络 获得图片
        //这个ad方案不好 侵入性太强 还是做到keywindow上加个 uiview 遮罩是更好的做法 这样也没法让 rootview预先加载 以后换
        //1.显示启动广告
        let frame = CGRectMake(0, 0, self.window!.bounds.size.width, self.window!.bounds.size.height-150)
        XHLaunchAd.showWithAdFrame( frame, setAdImage: { launchAd in
            
            //未检测到广告数据,启动页停留时间,默认3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
            launchAd.noDataDuration = 3
            
            //广告图片地址
            let imgUrl   = "http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"
            //广告停留时间
            let duration = 3
            //广告点击跳转链接

            //2.设置广告数据
                launchAd.setImageUrl(imgUrl, duration: duration, skipType:SkipType.TimeText , options: XHWebImageOptions.Default, completed: { img, url in
                    //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                    //weakLaunchAd.adFrame = ...;
                }, click: {
                    //1.用浏览器打开
//                    let openUrl  =  "http://www.returnoc.com";
//                    UIApplication.sharedApplication().openURL(NSURL(string:openUrl)!)
                    //2.在webview中打开
                   
//                    WebViewController *VC = [[WebViewController alloc] init];
//                    VC.URLString = openUrl;
//                    [weakLaunchAd presentViewController:VC animated:YES completion:nil];
//                    self.configRootVC()
//                    XHLaunchAd.dismissVC()

                    
                    if ( self.is_started_root_vc == false){
                        self.configRootVC()
                        self.is_started_root_vc = true
                    }
                    
                    launchAd.view.hidden = true

//                }];
                })
        }) {
            if ( self.is_started_root_vc == false){
                self.configRootVC()
                self.is_started_root_vc = true

            }
        }
        
//        [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height-150) setAdImage:^(XHLaunchAd *launchAd) {
//
//            
//            //广告图片地址
//            NSString *imgUrl = @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg";
//            //广告停留时间
//            NSInteger duration = 6;
//            //广告点击跳转链接
//            NSString *openUrl = @"http://www.returnoc.com";
//            
//            //2.设置广告数据
//            /定义一个weakLaunchAd
//            __weak __typeof(launchAd) weakLaunchAd = launchAd;
//            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
//            
//            
//            } click:^{
//            
//                       //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
//            
//            //2.在webview中打开
//            WebViewController *VC = [[WebViewController alloc] init];
//            VC.URLString = openUrl;
//            [weakLaunchAd presentViewController:VC animated:YES completion:nil];
//            
//            }];
//            
//            } showFinish:^{
//            
//            //广告展示完成回调,设置window根控制器
//            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
//            
//            }];
        
        
        
    }
    
    func asyncLoad(){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) { [unowned self] in
            CityDataManager.data
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        DLog("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {

        DLog("applicationDidEnterBackground")

    }
    
    func applicationWillEnterForeground(application: UIApplication) {

        DLog("applicationWillEnterForeground")

    }
    
    
    func applicationWillTerminate(application: UIApplication) {

        DLog("applicationWillTerminate")

    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UMSocialSnsService.applicationDidBecomeActive()
    }
    
    
    
    func application(application: UIApplication,  userActivity: NSUserActivity,  restorationHandler: ([AnyObject]?) -> Void) -> Bool
    {
        //DeepShare
        if DeepShare.continueUserActivity(userActivity) {
            return true
        }
        
        
        return true
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if Pingpp.handleOpenURL(url, withCompletion: nil) {
            return true
        }
        
        
        //growing io
        if Growing.handleUrl(url) {
            return true
        }
        
        //DeepShare
        if DeepShare.handleURL(url) {
            return true
        }
        
        
//        if MonkeyKing.handleOpenURL(url) {
//            return true
//        }
        if UMSocialSnsService.handleOpenURL(url) {
            return true
        }
        return true
    }
    
    // iOS 9 以上请用这个
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        Pingpp.handleOpenURL(url, withCompletion: nil)
        UMSocialSnsService.handleOpenURL(url)
        
        
        //growing io
        if Growing.handleUrl(url) {
            return true
        }
        
        //DeepShare
        if DeepShare.handleURL(url) {
            return true
        }
        
        return true
    }
    
    
    
}




extension AppDelegate:DeepShareDelegate{
    
    func rootVCGuide(){
        let nav = UIStoryboard.initNavVC("Login", identifier:String(WOWGuideController))
        nav.navigationController?.setNavigationBarHidden(true, animated: false)
        nav.navigationBarHidden = true
        window?.rootViewController =    nav
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
            rootVCGuide()
            
        }else{
            
            let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
            AppDelegate.rootVC = mainVC
            window?.rootViewController = mainVC
            
        }
        


//        window?.rootViewController =  UIStoryboard.initNavVC("Found", identifier:String(VCCategory))
//        window?.rootViewController =  UIStoryboard.initialViewController("Found")
//          window?.rootViewController =  VCBuy(nibName: nil, bundle: nil)
//        let vc_designer_list = UIStoryboard.initialViewController("Designer", identifier:String(VCDesignerList)) as! VCDesignerList
//        window?.rootViewController =  vc_designer_list
//          window?.rootViewController = UINavigationController(rootViewController: VCCategoryChoose())
        
//        window?.rootViewController = UINavigationController(rootViewController: VCShopping())
    }
    

    func onInappDataReturned(params: [NSObject : AnyObject]!, withError error: NSError!) {
        
        if ((error == nil)) {
            DLog("finished init with params = \(params.description)");
            let name  = params["name"]
//            goToLinuxCmd(cmdName); //调用应用自己的接口跳转到分享时页面
        } else {
            DLog("init error id: \(error.code) error.toString()");
        }
    }
    
    func registAppKey(launchOptions: [NSObject: AnyObject]?){
        //友盟
        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
        UMAnalyticsConfig.sharedInstance().channelId = ""
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        MobClick.setCrashReportEnabled(true)
        
        UMSocialData.setAppKey(WOWID.UMeng.appID)
        UMSocialWechatHandler.setWXAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey, url:"http://www.wowdsgn.com/")
        
        //Growing
        Growing.startWithAccountId("a04e14656f08dc7e")
        //DeepShare
        DeepShare.initWithAppID("e494427d3e67f207", withLaunchOptions: launchOptions, withDelegate: self)
        //Talking Data
        TalkingData.sessionStarted("88C9035CD51E8009BE4441263D83003A", withChannelId: "app store")
        
        
        
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
