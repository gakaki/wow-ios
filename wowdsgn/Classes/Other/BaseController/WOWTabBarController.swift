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
    func configureCell(_ cell: UITableViewCell, forRowAtIndexPath: IndexPath) {
        
    }
    //MARK:Private Method
    func setViewControllers(){
        
        self.view.backgroundColor   = tabBackColor
        
        self.tabBar.backgroundColor = UIColor(hexString: "#FFFFFF")
        self.tabBar.barTintColor = tabBackColor
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.isTranslucent = false
//        self.tabBar.shadowImage = UIImage.imageWithColor(MGRgb(234, g: 234, b: 234), size:CGSize(width: MGScreenWidth, height: 0.5))
//        self.tabBar.shadowImage = UIImage(named: "line")
        
//        self.view.backgroundColor   = tabBackColor
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = MGRgb(234, g: 234, b: 234).cgColor
        self.tabBar.clipsToBounds = true
        
        self.delegate               = self
        
        let storys =        ["Home",    "Found",       "HotStyle",        "Enjoy",     "User"      ]
        let images =        ["tab_home","tab_shopping","tab_special",  "tab_like",     "tab_me"    ]
        let imagesTitle =   ["首页",      "分类",       "灵感",          "欣赏",          "我"        ]
    

        
        var viewControllers = [UIViewController]()
        for index in 0..<storys.count{
            let vc = UIStoryboard.initialViewController(storys[index])
            vc.tabBarItem.image = UIImage(named:images[index])?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named:images[index] + "_selected")?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.title = imagesTitle[index]

            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)

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
            
            let dic_corlor   = NSDictionary(object: WowColor.gray,
                                            forKey: NSForegroundColorAttributeName as NSCopying)

            let dic_selected = NSDictionary(object: WowColor.blackLight,
                                   forKey: NSForegroundColorAttributeName as NSCopying)

            item.setTitleTextAttributes(dic_selected as? [String : AnyObject],
                                        for: UIControlState.selected)

            
            item.setTitleTextAttributes(dic_corlor as? [String : AnyObject],
                                        for: UIControlState())
        }
    }
    func configBadge(){
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
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let controllers = tabBarController.viewControllers
        let index = controllers?.index(of: viewController)
        if index == 3 || index == 4{
            guard WOWUserManager.loginStatus else {
                UIApplication.currentViewController()?.toLoginVC(true)
                return false
            }
        }

        if let i = controllers?.index(of: viewController) {
            switch i {
            case  0:
                MobClick.e(.Home)
            case  1:
                MobClick.e(.Shopping)
            case  2:
                MobClick.e(.Selection)
            case  3:
                MobClick.e(.Like)
            case  4:
                MobClick.e(.Me)
            default:
                MobClick.e(.Home)
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


