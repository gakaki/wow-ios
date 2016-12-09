//
//  UmengHelper.swift
//  Pods
//
//  Created by g on 16/10/26.
//
//

import UIKit
//import UserNotifications
//import UserNotificationsUI
import wow3rd


public class AppDelegateUmengHelper:NSObject,UNUserNotificationCenterDelegate,UIApplicationDelegate  {
    
    public func init_umessage(_ launchOptions:[AnyHashable: Any]?){
        print("init_umessage")
        
        if Platform.isSimulator == false {
            //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
            UMessage.start(withAppkey: Config3rd.umessage_app_key, launchOptions: launchOptions, httpsenable: false)
            
            //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
            UMessage.registerForRemoteNotifications()
            
            //iOS10必须加下面这段代码。
            if #available(iOS 10.0, *) {
                let center                              = UNUserNotificationCenter.current()
                center.delegate                         = self
                let types10:UNAuthorizationOptions      = [UNAuthorizationOptions.badge,UNAuthorizationOptions.alert,UNAuthorizationOptions.sound]
                center.requestAuthorization(options: types10, completionHandler: { (granted, e) in
                    if (granted) {
                        //点击允许
                        //这里可以添加一些自己的逻辑
                    } else {
                        //点击不允许
                        //这里可以添加一些自己的逻辑
                    }
                })
            }
            //打开日志，方便调试
            UMessage.setLogEnabled(true)
        }
        
    }
  
    
    //iOS10以下使用这个方法接收通知
//    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        //关闭友https://img.alicdn.com/consult/TB1vZKXOFXXXXabapXXwu0bFXXX.png盟自带的弹出框
//        UMessage.setAutoAlert(false)
//        pushController(userInfo: userInfo)
//        UMessage.didReceiveRemoteNotification(userInfo)
//        
//        //    self.userInfo = userInfo;
//        //    //定制自定的的弹出框
//        //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//        //    {
//        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//        //                                                            message:@"Test On ApplicationStateActive"
//        //                                                           delegate:self
//        //                                                  cancelButtonTitle:@"确定"
//        //                                                  otherButtonTitles:nil];
//        //
//        //        [alertView show];
//        //
//        //    }
//
//    }
   

    
    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            //handle url
            
            let d = " get url is \(url) , url string is \(url.absoluteString)"
            print(d)
            
            return true
        }
        
        
        return true
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            UMessage.setAutoAlert(false)
//            pushController(userInfo: userInfo)
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            
        }
        
        //应用处于前台时的本地推送接受
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler([UNNotificationPresentationOptions.badge,UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound])
        
    }
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            //应用处于后台时的远程推送接受
            pushController(userInfo: userInfo)
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于后台时的本地推送接受
            
        }
    }
    
    func pushController(userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let dic :[String: AnyObject]? = userInfo as? [String : AnyObject]
        if let dic = dic {
            var type: String?
            var id: String?
            type = dic["type"] as? String
            id = dic["id"] as? String
            if let type = type {
                switch type {
                case "101"://首页
                    
                    let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                    UIApplication.appTabBarController.selectedIndex = 0
                    WOWTool.lastTabIndex = 0
                case "102"://购物

                    let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                    UIApplication.appTabBarController.selectedIndex = 1
                    WOWTool.lastTabIndex = 1
                    
                case "103"://精选
                    let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                    UIApplication.appTabBarController.selectedIndex = 2
                    WOWTool.lastTabIndex = 2

                case "104"://喜欢
                    guard WOWUserManager.loginStatus else{
                        UIApplication.currentViewController()?.toLoginVC(true)
                        return
                    }
                    let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                    UIApplication.appTabBarController.selectedIndex = 3
                    WOWTool.lastTabIndex = 3
                case "105"://我
                    let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                    UIApplication.appTabBarController.selectedIndex = 4
                    WOWTool.lastTabIndex = 4

                case "201"://商品详情
                    if let id = id {
                        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
                        vc.hideNavigationBar = true
                        vc.productId = id.toInt()
                        UIApplication.currentViewController()?.pushVC(vc)
                    }
                    
                case "202"://内容专题详情
                    if let id = id {
                        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
                        //                vc.hideNavigationBar = true
                        vc.topic_id = id.toInt() ?? 0
                        UIApplication.currentViewController()?.pushVC(vc)
                        
                    }
                    
                case "203"://商品列表专题详情
                    if let id = id {
                        let vc                  = VCTopic(nibName: nil, bundle: nil)
                        vc.topic_id             = id.toInt() ?? 0
                        vc.hideNavigationBar    = true
                        UIApplication.currentViewController()?.pushVC(vc)
                        
                    }
                case "204"://H5
                    let vc = WOWWebViewController()
                    if let url = id{
                        vc.url = url
                    }

                    UIApplication.currentViewController()?.pushVC(vc)
                        
                case "205"://品牌详情
                    if let id = id {
                        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                        vc.brandID = id.toInt()
                        vc.entrance = .brandEntrance
                        vc.hideNavigationBar = true
                        UIApplication.currentViewController()?.pushVC(vc)
                        
                    }
                case "206"://设计师详情
                    if let id = id {
                        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                        vc.designerId = id.toInt()
                        vc.entrance = .designerEntrance
                        vc.hideNavigationBar = true

                        UIApplication.currentViewController()?.pushVC(vc)
                        
                    }
                case "207"://分类详情
                    if let id = id {
                        let vc              = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: VCCategory.self)) as! VCCategory
                        vc.ob_cid.value     = id.toInt() ?? 10
//                        vc.title    = cname!
                        UIApplication.currentViewController()?.pushVC(vc)
                        
                    }
                case "208"://优惠券列表
                    guard WOWUserManager.loginStatus else{
                        UIApplication.currentViewController()?.toLoginVC(true)
                        return
                    }
                    let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
                    vc.entrance = couponEntrance.userEntrance
                    UIApplication.currentViewController()?.pushVC(vc)
                case "209"://订单列表
                    if let id = id {
                        guard WOWUserManager.loginStatus else{
                            UIApplication.currentViewController()?.toLoginVC(true)
                            return
                        }
                        let vc = WOWOrderListViewController()
                        vc.selectCurrentIndex = id.toInt() ?? 0
                        UIApplication.currentViewController()?.pushVC(vc)
                    }
                    
                default:
                    break
                }
            }
        }
        
//        let type = userInfo["type"]
        
    }
    
}
