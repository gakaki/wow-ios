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
    var full_address: String?
    var isDefault   : Int?
    var id          : String?
    
    required init?(_ map: Map) {
        
    }
    
     func mapping(map: Map) {
        name        <- map["receiverName"]
        city        <- map["cityId"]
        district    <- map["district"]
        street      <- map["street"]
        province    <- map["provinceId"]
        mobile      <- map["receiverMobile"]
        isDefault   <- map["isDefault"]
        id          <- map["id"]
        full_address <- map["addressDetail"]
    }
}
