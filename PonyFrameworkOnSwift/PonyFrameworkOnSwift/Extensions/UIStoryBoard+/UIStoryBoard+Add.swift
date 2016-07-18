//
//  UIStoryBoard+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    /**
     根据stroyboard名称返回初始控制器
     
     - parameter name: 名称
     
     - returns: 初始控制器
     */
    class func initialViewController(name: String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /**
     根据stroyboard名称和标示符返回对应的控制器
     
     - parameter name:       名称
     - parameter identifier: 标示符
     
     - returns: 对应的控制器
     */
    class func initialViewController(name: String, identifier: String) -> UIViewController
    {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateViewControllerWithIdentifier(identifier)
    }
    
    
    class func initNavVC(name: String, identifier: String) -> UINavigationController {
        let sb      = UIStoryboard(name: name, bundle: nil)
        let nav_vc  = UINavigationController.init(rootViewController: sb.instantiateViewControllerWithIdentifier(identifier))
        
        return nav_vc
    }

}