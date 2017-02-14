//
//  WOWUserModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
import ObjectMapper

class WOWUserModel:NSObject,Mappable{
    var sessionToken        : String?
    var user_desc           : String?
    var user_headimage      : String?
    var user_nick           : String?
    var user_mobile         : String?
    var user_industry       : String?
    var user_email          : String?
    var bindWechat          : Bool?
    var user_sex            : Int?
    var user_carCount       : Int?
    var user_constellation  : Int?
    var user_ageRange       : Int?
    var user_id             : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_desc           <- map["selfIntroduction"]
        user_headimage      <- map["avatar"]
        user_nick           <- map["nickName"]
        user_constellation  <- map["constellation"]
        user_sex            <- map["sex"]
        user_industry       <- map["industry"]
        user_ageRange       <- map["ageRange"]
        user_mobile         <- map["mobile"]
        user_email          <- map["email"]
        bindWechat          <- map["bindWechat"]
        //FIXME:后台要返回的
        user_carCount       <- map["productQtyInCart"]
        user_id             <- map["endUserId"]
    }
    
}
