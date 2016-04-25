//
//  WOWUserManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation


struct WOWUserManager {
    static let WOWUserID            = "WOWUserID"
    static let WOWUserHeadImage     = "WOWUserHeadImage"
    static let WOWUserName          = "WOWUserName"
    
    static var userHeadImageUrl:String{
        get{
            return (MGDefault.objectForKey(WOWUserHeadImage) as? String) ?? ""
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserHeadImage)
            MGDefault.synchronize()
        }
    }
    
    
    static var userID:String{
        get{
            return (MGDefault.objectForKey(WOWUserID) as? String) ?? ""
        }
    }
    
    static var userName:String{
        get{
            return (MGDefault.objectForKey(WOWUserName) as? String) ?? ""
        }
        
        set{
            MGDefault.setObject(newValue, forKey:WOWUserName)
            MGDefault.synchronize()
        }
    }
    
    static var loginStatus:Bool{
        get{
            guard !userID.isEmpty else{
                return false
            }
            return true
        }
    }
    
    
    static func saveUserInfo(data:AnyObject){
        let model = Mapper<WOWUserModel>().map(data)
        MGDefault.setObject(model?.userID, forKey:WOWUserID)
        //FIXME:测试的userID
        MGDefault.setObject("456789", forKey:WOWUserID)
        MGDefault.synchronize()
    }
    
    
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        MGDefault.setObject(nil, forKey: WOWUserID)
        MGDefault.setObject(nil, forKey: WOWUserHeadImage)
        MGDefault.synchronize()
    }
    
}