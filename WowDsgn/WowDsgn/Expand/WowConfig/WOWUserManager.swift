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
    
    static var loginStatus:Bool{
        get{
            guard let _ = fetchUserID() where !WOWUserID.isEmpty else{
                return false
            }
            return true
        }
    }
    
    static var userHeadImage:UIImage?{
        get {
            let data =  MGDefault.objectForKey(WOWUserHeadImage) as? NSData
            if let d = data {
                return UIImage(data:d)
            }
            return nil
        }
    }
    
    
    static func saveUserInfo(data:AnyObject){
        let model = Mapper<WOWUserModel>().map(data)
        MGDefault.setObject(model?.userID, forKey:WOWUserID)
        
        
        MGDefault.synchronize()
    }
    
    /**
     保存用户头像
     
     - parameter image:
     */
    static func saveUserHeadImage(image:UIImage?){
        if let headImage = image {
            let data = UIImagePNGRepresentation(headImage)
            MGDefault.setObject(data, forKey:WOWUserHeadImage)
            MGDefault.synchronize()
        }
    }
    
    /**
     保存用户昵称
     */
    static func saveUserName(name:String?){
        MGDefault.setObject(name, forKey:WOWUserName)
        MGDefault.synchronize()
    }
    
    
    
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        MGDefault.setObject(nil, forKey: WOWUserID)
        
        
        MGDefault.synchronize()
    }
    
    
    static func fetchUserID() -> String?{
        return MGDefault.objectForKey(WOWUserID) as? String
    }
    
    
}