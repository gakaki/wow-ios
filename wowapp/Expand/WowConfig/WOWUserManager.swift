//
//  WOWUserManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation


struct WOWUserManager {
    private static let WOWUserID            = "WOWUserID"
    private static let WOWUserHeadImage     = "WOWUserHeadImage"
    private static let WOWUserName          = "WOWUserName"
    private static let WOWUserSex           = "WOWUserSex"
    private static let WOWUserDes           = "WOWUserDes"
    private static let WOWUserEmail         = "WOWUserEmail"
    private static let WOWUserMobile        = "WOWUserMobile"
    private static let WOWUserCarCount      = "WOWUserCarCount"
    private static let WOWSessionToken      = "WOWSessionToken"
    private static let WOWUserIndustry      = "WOWUserIndustry"
    private static let WOWUserConstellation = "WOWUserConstellation"
    private static let WOWUserAgeRange      = "WOWUserAgeRange"

    static var wechatToken = ""
    
    static var sessionToken:String {
        get{
            return (MGDefault.objectForKey(WOWSessionToken) as? String) ?? ""
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWSessionToken)
            MGDefault.synchronize()
        }
    }

    static var userCarCount:Int{
        get{
            return (MGDefault.objectForKey(WOWUserCarCount) as? Int) ?? 0
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserCarCount)
            MGDefault.synchronize()
        }
    }
    
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
            let name = (MGDefault.objectForKey(WOWUserName) as? String) ?? ""
            if name.isEmpty {
                if self.userMobile.isEmpty {
                    if self.userEmail.isEmpty {
                        return ""
                    }else{
                        return self.userEmail
                    }
                }else{
                    return self.userMobile
                }
            }else{
                return name
            }
        }
        
        set{
            MGDefault.setObject(newValue, forKey:WOWUserName)
            MGDefault.synchronize()
        }
    }
    
    static var userEmail:String{
        get{
            return (MGDefault.objectForKey(WOWUserEmail) as? String) ?? ""
        }
    }
    
    static var userMobile:String{
        get{
            return (MGDefault.objectForKey(WOWUserMobile) as? String) ?? ""
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserMobile)
            MGDefault.synchronize()
        }
    }
    
    static var userSex:Int{
        get{
            return (MGDefault.objectForKey(WOWUserConstellation) as? Int) ?? 3
        }

        set{
            MGDefault.setObject(newValue, forKey:WOWUserSex)
            MGDefault.synchronize()
        }
    }
    
    static var userConstellation:Int{
        get{
            return (MGDefault.objectForKey(WOWUserConstellation) as? Int) ?? 0
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserConstellation)
            MGDefault.synchronize()
        }
    }
    static var userAgeRange:Int{
        get{
            return (MGDefault.objectForKey(WOWUserAgeRange) as? Int) ?? 0
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserAgeRange)
            MGDefault.synchronize()
        }
    }
    
    static var userDes:String{
        get{
            let des = (MGDefault.objectForKey(WOWUserDes) as? String) ?? ""
            if des.isEmpty {
                return "点击修改签名"
            }else{
                return des
            }
        }
        
        set{
            MGDefault.setObject(newValue, forKey:WOWUserDes)
            MGDefault.synchronize()
        }
    }
    static var userIndustry:String{
        get{
            return (MGDefault.objectForKey(WOWUserIndustry) as? String) ?? ""
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWUserIndustry)
            MGDefault.synchronize()
        }
    }
    static var loginStatus:Bool{
        get{
            guard !sessionToken.isEmpty else{
                return false
            }
            return true
        }
    }
    
    
    static func saveUserInfo(model:WOWUserModel?){
        MGDefault.setObject(model?.user_nick, forKey:WOWUserName)
        MGDefault.setObject(model?.user_sex, forKey:WOWUserSex)
        MGDefault.setObject(model?.user_nick, forKey:WOWUserName)
        MGDefault.setObject(model?.user_desc, forKey:WOWUserDes)
        MGDefault.setObject(model?.user_headimage, forKey:WOWUserHeadImage)
        MGDefault.setObject(model?.user_constellation, forKey:WOWUserConstellation)
        MGDefault.setObject(model?.user_ageRange, forKey:WOWUserAgeRange)
        MGDefault.setObject(model?.user_carCount, forKey:WOWUserCarCount)
        MGDefault.setObject(model?.user_industry, forKey:WOWUserIndustry)
        MGDefault.synchronize()
    }
    
    
    /**
     退出登录
     清空用户的各个信息
     */
    static func exitLogin(){
        MGDefault.setObject(nil, forKey: WOWUserCarCount)
        MGDefault.setObject(nil, forKey: WOWSessionToken)
        MGDefault.setObject(nil, forKey: WOWUserHeadImage)
        MGDefault.synchronize()
        WOWBuyCarMananger.updateBadge()
    }
    
    
}
