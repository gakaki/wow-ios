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
    dynamic var productID :String          = ""
    dynamic var skus:[WOWProductSkuModel]  = [WOWProductSkuModel]()
    
    override static func primaryKey() -> String? {
        return "skuID"
    }

    override static func ignoredProperties() -> [String] {
        return ["skus"]
    }
    
    
    func mapping(map: Map) {
        skuProductCount         <- map["count"]
        skuProductName          <- map["product_name"]
        skuProductPrice         <- map["price"]
        skuProductImageUrl      <- map["product_image"]
        skuName                 <- map["sku_title"]
        skuID                   <- map["sku_id"]
        productID               <- map["id"]
        skus                    <- map["skus"]
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
}
