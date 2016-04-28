//
//  WOWAddressListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/28.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWAddressListModel: WOWBaseModel,Mappable{
    var name        : String?
    var city        : String?
    var district    : String?
    var street      : String?
    var province    : String?
    var mobile      : String?
    var isDefault   : Int?
    
    required init?(_ map: Map) {
        
    }
    
     func mapping(map: Map) {
        name  <- map["name"]
        name  <- map["city"]
        name  <- map["district"]
        name  <- map["street"]
        name  <- map["province"]
        name  <- map["mobile"]
        name  <- map["is_default"]
    }
}
