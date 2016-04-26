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
    static let WOWUserSex           = "WOWUserSex"
    static let WOWUserDes           = "WOWUserDes"
    
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
    
    static var userSex:String{
        get{
            return (MGDefault.objectForKey(WOWUserSex) as? String) ?? ""
        }
        
        set{
            MGDefault.setObject(newValue, forKey:WOWUserSex)
            MGDefault.synchronize()
        }
    }
    
    static var userDes:String{
        get{
            return (MGDefault.objectForKey(WOWUserDes) as? String) ?? ""
        }
        
        set{
            MGDefault.setObject(newValue, forKey:WOWUserDes)
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
    
    
    static func saveUserInfo(model:WOWUserModel?){
        //FIXME:测试的userID
        MGDefault.setObject(model?.userID, forKey:WOWUserID)
        MGDefault.setObject(model?.user_sex, forKey:WOWUserSex)
        MGDefault.setObject(model?.user_nick, forKey:WOWUserName)
        MGDefault.setObject(model?.user_desc, forKey:WOWUserDes)
        MGDefault.setObject(model?.user_headimage, forKey:WOWUserHeadImage)
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