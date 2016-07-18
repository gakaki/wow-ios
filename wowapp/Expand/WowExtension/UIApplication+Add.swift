//
//  UIApplication+Add.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

extension UIApplication{    
    class var appTabBarController:UITabBarController {
        get{
            return AppDelegate.rootVC as! UITabBarController
        }
    }


}