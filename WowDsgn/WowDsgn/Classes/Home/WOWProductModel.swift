//
//  WOWProductModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWProductModel: WOWBaseModel,Mappable{
    var productID:String?
    var productName:String?
    var productX:Float?
    var productY:Float?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID   <- map["id"]
        productName <- map["name"]
        productX    <- map["x"]
        productY    <- map["y"]
    }
}
