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
    //MARK: UITableViewDataSource
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        
    }
    //MARK:Private Method
    func setViewControllers(){
        self.view.backgroundColor = DefaultBackColor
        self.delegate = self;
        let storys = ["Home","Favorite","Found","Brand","User"]
        let images = ["home","Favorite","store","brand","me"]
        let imagesTitle = ["首页","分类","尖叫","喜欢","我"]
        var viewControllers = [UIViewController]()
        for index in 0..<storys.count{
            let vc = UIStoryboard.initialViewController(storys[index])
            vc.tabBarItem.image = UIImage(named:images[index])?.imageWithRenderingMode(.AlwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named:images[index] + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
            
//            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
            
            vc.tabBarItem.title = imagesTitle[index]

            viewControllers.append(vc)
        }
        self.viewControllers = viewControllers
        WOWTool.lastTabIndex = 0
//        configBadge()
        configTabBar()
    }
    func configTabBar() {
        let items = self.tabBar.items
        for item in items! as [UITabBarItem] {
            let dic = NSDictionary(object: UIColor.yellowColor(),
                                   forKey: NSForegroundColorAttributeName)

            item.setTitleTextAttributes(dic as? [String : AnyObject],
                                        forState: UIControlState.Selected)
        }
    }
    private func configBadge(){
        WOWBuyCarMananger.updateBadge()
//        if WOWUserManager.loginStatus { //登录了
//           //FIXME:赞不考虑与电脑同步
//            WOWBuyCarMananger.updateBadge()
//        }else{ //未登录
//            WOWBuyCarMananger.updateBadge()
//        }
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
    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//            let controllers = tabBarController.viewControllers
//            let index = controllers?.indexOf(viewController)
//            if index == 1{
//                guard WOWUserManager.loginStatus else {
//                     UIApplication.currentViewController()?.toLoginVC(true)
//                    return
//                }
//            }
//        
//        WOWTool.lastTabIndex = index ?? 0
//    }

//    //将要点击
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let controllers = tabBarController.viewControllers
        let index = controllers?.indexOf(viewController)
        if index == 1{
            guard WOWUserManager.loginStatus else {
                UIApplication.currentViewController()?.toLoginVC(true)
                return false
            }
        }
        
        WOWTool.lastTabIndex = index ?? 0
        return true
    }
    
//
//    func showBuyCar(){
//        let buyCar = UIStoryboard.initialViewController("BuyCar")
//
//        self.presentViewController(buyCar, animated: true, completion: nil)
//    }
}


