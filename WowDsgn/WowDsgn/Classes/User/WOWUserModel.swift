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
    var userName : String?
    var userID   : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userName   <- map["userName"]
        userID     <- map["userID"]
    }
    
}