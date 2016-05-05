//
//  WOWBrandModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWBrandModel: WOWBaseModel,Mappable {
    var id         : String?
    var name       : String?
    var image      : String?
    var url        : String?
    var products   : [WOWProductModel]?
    var desc       : String?
    
    required init?(_ map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        image    <- map["image"]
        url      <- map["url"]
        products <- map["products"]
        desc     <- map["desc"]
    }
}
