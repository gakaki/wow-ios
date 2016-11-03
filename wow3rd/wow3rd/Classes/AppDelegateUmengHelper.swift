//
//  UmengHelper.swift
//  Pods
//
//  Created by g on 16/10/26.
//
//

import UIKit


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
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        print(deviceToken)
        // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
        UMessage.registerDeviceToken(deviceToken)
        //        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    
    //iOS10以下使用这个方法接收通知
    public  func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]){
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        
        //    self.userInfo = userInfo;
        //    //定制自定的的弹出框
        //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        //    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
        //                                                            message:@"Test On ApplicationStateActive"
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"确定"
        //                                                  otherButtonTitles:nil];
        //
        //        [alertView show];
        //
        //    }
    }
    
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
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于后台时的本地推送接受
            
        }
    }
    
    
}
