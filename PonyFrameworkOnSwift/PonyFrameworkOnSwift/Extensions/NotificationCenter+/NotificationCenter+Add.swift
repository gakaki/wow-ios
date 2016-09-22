//
//  NotificationCenter+Add.swift
//  SwiftProject
//
//  Created by 王云鹏 on 16/3/2.
//  Copyright © 2016年 王涛. All rights reserved.
//

import Foundation
public extension NotificationCenter{
   static func postNotificationOnMainThread(_ notification:Notification){
        DispatchQueue.main.async { () -> Void in
            NotificationCenter.default.post(notification)
        }
    }
    
   static  func postNotificationNameOnMainThread(_ aName:String,object:AnyObject?){
        let not = Notification(name: Notification.Name(rawValue: aName), object: object)
        postNotificationOnMainThread(not)
    }
    
    static func postNotificationNameOnMainThread(_ aName:String,object:AnyObject?,userInfo:[AnyHashable: Any]?){
        let not = Notification(name: Notification.Name(rawValue: aName), object: object, userInfo: userInfo)
        postNotificationOnMainThread(not)
    }
}
