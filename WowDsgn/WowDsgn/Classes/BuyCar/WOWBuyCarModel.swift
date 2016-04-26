//
//  WOWBuyCarModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWBuyCarModel: Object,Mappable{
    dynamic var skuProductCount:Int        = 1
    dynamic var skuProductName:String      = ""
    dynamic var skuProductPrice:String     = ""
    dynamic var skuProductImageUrl:String  = ""
    dynamic var skuName:String             = ""
    dynamic var skuID  :String             = ""
    
    override static func primaryKey() -> String? {
        return "skuID"
    }

    
    func mapping(map: Map) {
        
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
}
