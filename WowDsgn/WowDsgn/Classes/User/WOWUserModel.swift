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
    var userID          : String?
    var user_desc       : String?
    var user_headimage  : String?
    var user_nick       : String?
    var user_sex        : String?
    var user_mobile     : String?
    var user_email      : String?
    var user_carCount   : Int?
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userID           <- map["uid"]
        user_desc        <- map["desc"]
        user_headimage   <- map["headimage"]
        user_nick        <- map["nick"]
        user_sex         <- map["sex"]
        user_mobile      <- map["mobile"]
        user_email       <- map["email"]
        //FIXME:后台要返回的
        user_carCount    <- map["carCount"]
    }
    
}