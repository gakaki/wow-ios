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
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userID           <- map["uid"]
        user_desc        <- map["user_desc"]
        user_headimage   <- map["user_headimage"]
        user_nick        <- map["user_nick"]
        user_sex         <- map["user_sex"]
    }
    
}