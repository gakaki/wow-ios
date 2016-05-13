//
//  NotificationCenter+Add.swift
//  SwiftProject
//
//  Created by 王云鹏 on 16/3/2.
//  Copyright © 2016年 王涛. All rights reserved.
//

import Foundation
public extension NSNotificationCenter{
   static func postNotificationOnMainThread(notification:NSNotification){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    
   static  func postNotificationNameOnMainThread(aName:String,object:AnyObject?){
        let not = NSNotification(name: aName, object: object)
        postNotificationOnMainThread(not)
    }
    
    static func postNotificationNameOnMainThread(aName:String,object:AnyObject?,userInfo:[NSObject:AnyObject]?){
        let not = NSNotification(name: aName, object: object, userInfo: userInfo)
        postNotificationOnMainThread(not)
    }
}