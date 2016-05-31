//
//  UIApplication+Add.swift
//  WowLib
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension UIApplication{

    class func currentViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return currentViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return currentViewController(presented)
        }
        
        return base
    }
}