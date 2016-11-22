//
//  WOWUserManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

//TODO
struct WOWUserManager {
     static let WOWUserID            = "WOWUserID"
     static let WOWUserHeadImage     = "WOWUserHeadImage"
     static let WOWUserName          = "WOWUserName"
     static let WOWUserSex           = "WOWUserSex"
     static let WOWUserDes           = "WOWUserDes"
     static let WOWUserEmail         = "WOWUserEmail"
     static let WOWUserMobile        = "WOWUserMobile"
     static let WOWUserCarCount      = "WOWUserCarCount"
     static let WOWSessionToken      = "WOWSessionToken"
     static let WOWUserIndustry      = "WOWUserIndustry"
     static let WOWUserConstellation = "WOWUserConstellation"
     static let WOWUserAgeRange      = "WOWUserAgeRange"
     static let WOWUserLoginStatus   = "WOWUserLoginStatus"
     static let WOWUserPhotoData     = "WOWUserPhotoData"


    static var wechatToken = ""
    
    static var sessionToken:String {
        get{
            return (MGDefault.object(forKey: WOWSessionToken) as? String) ?? ""
        }
        set{
            MGDefault.set(newValue, forKey:WOWSessionToken)
            MGDefault.synchronize()
        }
    }

    static var userCarCount:Int{
        get{
            return (MGDefault.object(forKey: WOWUserCarCount) as? Int) ?? 0
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserCarCount)
            MGDefault.synchronize()
        }
    }
    
    static var userHeadImageUrl:String{
        get{
            return (MGDefault.object(forKey: WOWUserHeadImage) as? String) ?? ""
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserHeadImage)
            MGDefault.synchronize()
        }
    }
    
    
    static var userID:String{
        get{
            return (MGDefault.object(forKey: WOWUserID) as? String) ?? ""
        }
    }
    
    static var userName:String{
        get{
            let name = (MGDefault.object(forKey: WOWUserName) as? String) ?? ""
            if name.isEmpty {
                return ""
            }else{
                return name
            }
        }
        
        set{
            MGDefault.set(newValue, forKey:WOWUserName)
            MGDefault.synchronize()
        }
    }
    
    static var userEmail:String{
        get{
            return (MGDefault.object(forKey: WOWUserEmail) as? String) ?? ""
        }
    }
    
    static var userMobile:String{
        get{
            return (MGDefault.object(forKey: WOWUserMobile) as? String) ?? ""
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserMobile)
            MGDefault.synchronize()
        }
    }
    static var userPhotoData:Data{
        get{
            
            if  let aaa = MGDefault.object(forKey: WOWUserPhotoData)  {
                 return (aaa as? Data) ?? Data()
            }else{
                return  Data()
            }
            
//            return (MGDefault.objectForKey(WOWUserPhotoData) as? NSData)!
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserPhotoData)
            MGDefault.synchronize()
        }
    }

    static var userSex:Int{
        get{
            return (MGDefault.object(forKey: WOWUserSex) as? Int) ?? 3
        }

        set{
            MGDefault.set(newValue, forKey:WOWUserSex)
            MGDefault.synchronize()
        }
    }
    
    static var userConstellation:Int{
        get{
            return (MGDefault.object(forKey: WOWUserConstellation) as? Int) ?? 0
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserConstellation)
            MGDefault.synchronize()
        }
    }
    static var userAgeRange:Int{
        get{
            return (MGDefault.object(forKey: WOWUserAgeRange) as? Int) ?? 0
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserAgeRange)
            MGDefault.synchronize()
        }
    }
    
    static var userDes:String{
        get{
            let des = (MGDefault.object(forKey: WOWUserDes) as? String) ?? ""
            if des.isEmpty {
                return ""
            }else{
                return des
            }
        }
        
        set{
            MGDefault.set(newValue, forKey:WOWUserDes)
            MGDefault.synchronize()
        }
    }
    static var userIndustry:String{
        get{
            return (MGDefault.object(forKey: WOWUserIndustry) as? String) ?? ""
        }
        set{
            MGDefault.set(newValue, forKey:WOWUserIndustry)
            MGDefault.synchronize()
        }
    }
    static var loginStatus:Bool{
        get{
            if sessionToken.isEmpty {
                return false
            }else {
                return true
            }
//            return (MGDefault.objectForKey(WOWUserLoginStatus) as? Bool) ?? false
        }
//        set{
//            MGDefault.setObject(newValue, forKey:WOWUserLoginStatus)
//            MGDefault.synchronize()
//        }
    }
    
   
    
    static func saveUserInfo(_ model:WOWUserModel?){
//        MGDefault.setObject(true, forKey: WOWUserLoginStatus)
        MGDefault.set(model?.user_nick, forKey:WOWUserName)
        MGDefault.set(model?.user_sex, forKey:WOWUserSex)
        MGDefault.set(model?.user_desc, forKey:WOWUserDes)
        MGDefault.set(model?.user_headimage, forKey:WOWUserHeadImage)
        MGDefault.set(model?.user_constellation, forKey:WOWUserConstellation)
        MGDefault.set(model?.user_ageRange, forKey:WOWUserAgeRange)
        MGDefault.set(model?.user_carCount, forKey:WOWUserCarCount)
        MGDefault.set(model?.user_industry, forKey:WOWUserIndustry)
        MGDefault.synchronize()
    }
    
    static func cleanUserInfo(){
//        MGDefault.setObject(false, forKey: WOWUserLoginStatus)
        MGDefault.set(nil, forKey:WOWUserName)
        MGDefault.set(nil, forKey:WOWUserSex)
        MGDefault.set(nil, forKey:WOWUserDes)
        MGDefault.set(nil, forKey:WOWUserHeadImage)
        MGDefault.set(nil, forKey:WOWUserConstellation)
        MGDefault.set(nil, forKey:WOWUserAgeRange)
        MGDefault.set(nil, forKey:WOWUserCarCount)
        MGDefault.set(nil, forKey:WOWUserIndustry)
        MGDefault.set("", forKey:WOWUserPhotoData)
        MGDefault.set(nil, forKey: WOWSessionToken)
        MGDefault.synchronize()
    }
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        cleanUserInfo()
    }
    
    
}
