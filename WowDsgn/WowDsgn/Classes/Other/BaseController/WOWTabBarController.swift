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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setViewControllers(){
        self.delegate = self;
        let storys = ["Home","Store","Activity","BuyCar","User"]
        let titles = ["尖叫","商店","活动","购物车","我"]
        let images = ["home","store","activity","buycar","me"]
        var viewControllers = [UIViewController]()
        for index in 0..<storys.count{
            let vc = UIStoryboard.initialViewController(storys[index])
            vc.tabBarItem.title = titles[index]
            vc.tabBarItem.image = UIImage(named:images[index])?.imageWithRenderingMode(.AlwaysOriginal)
            vc.tabBarItem.selectedImage = UIImage(named:images[index] + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
            viewControllers.append(vc)
        }
        self.viewControllers = viewControllers
    }
}

extension WOWTabBarController:UITabBarControllerDelegate{
    //将要点击
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        let controllers = tabBarController.viewControllers
//        let index = controllers?.indexOf(viewController)
//        if index == 3{
//            showBuyCar()
//            return false
//        }
        return true
    }
    
    func showBuyCar(){
        let buyCar = UIStoryboard.initialViewController("BuyCar")
        self.presentViewController(buyCar, animated: true, completion: nil)
    }
}


