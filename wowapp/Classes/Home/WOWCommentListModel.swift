//
//  WOWCommentListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/27.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWCommentListModel: WOWBaseModel,Mappable{
    var comment         : String?
    var created_at      : String?
    var email           : String?
    var user_headimage  : String?
    var user_nick       : String?
    var mobile          : String?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        comment         <- map["comment"]
        created_at      <- map["created_at"]
        email           <- map["email"]
        user_headimage  <- map["user_headimage"]
        user_nick       <- map["user_nick"]
        mobile          <- map["mobile"]
    }
}
