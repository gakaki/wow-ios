//
//  WOWTabBarController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/17.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
//        configNetReachable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK:Private Method
    func setViewControllers(){
        self.delegate = self;
        let storys = ["Home","Store",/*"Activity",*/"BuyCar","User"]
        let titles = ["尖叫","商店",/*"活动",*/"购物车","我"]
        let images = ["home","store",/*"activity",*/"buycar","me"]
        var viewControllers = [UIViewController]()
        for index in 0..<storys.count{
            let vc = UIStoryboard.initialViewController(storys[index])
            vc.tabBarItem.title = titles[index]
            vc.tabBarItem.image = UIImage(named:images[index])?.imageWithRenderingMode(.AlwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named:images[index] + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
            viewControllers.append(vc)
        }
        self.viewControllers = viewControllers
        configBadge()
    }
    
    private func configBadge(){
        let vc = self.viewControllers![2]
        if WOWUserManager.loginStatus { //登录了
           //FIXME:赞不考虑与电脑同步
            
        }else{ //未登录
            WOWBuyCarMananger.updateBadge()
        }
    }
    
    /**
     网络监测
 
    func configNetReachable() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    DLog("Wift")
                } else {
                    DLog("")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "网络故障", message:"您似乎脱离了与互联网的链接", preferredStyle:.Alert)
                let action = UIAlertAction(title: "我知道了", style: .Default, handler:nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    */
}

extension WOWTabBarController:UITabBarControllerDelegate{
    //将要点击
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let controllers = tabBarController.viewControllers
        let index = controllers?.indexOf(viewController)
        if index == 2{
            showBuyCar()
            return false
        }
        return true
    }
    
    func showBuyCar(){
        let buyCar = UIStoryboard.initialViewController("BuyCar")

        self.presentViewController(buyCar, animated: true, completion: nil)
    }
}


