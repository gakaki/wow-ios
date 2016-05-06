//
//  WOWOrderListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/2.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper


class WOWOrderListModel: WOWBaseModel,Mappable{
    var id              : String?
    var products        : [WOWOrderProductModel]?
    var status          : Int? 
    var status_chs      : String?
    var total           : String?
    var address_full    : String?
    var pay_method      : String?
    var address_username: String?
    var address_mobile  : String?
    var created_at      : String?
    var tips            : String?
    var charge          : AnyObject?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        products            <- map["items"]
        status              <- map["status"]
        status_chs          <- map["status_chs"]
        total               <- map["total"]
        address_full        <- map["address_full"]
        pay_method          <- map["pay_method"]
        address_username    <- map["address_username"]
        address_mobile      <- map["address_mobile"]
        created_at          <- map["created_at"]
        tips                <- map["tips"]
        charge              <- map["charge"]
    }
}

class WOWOrderProductModel: WOWBaseModel ,Mappable{
    var name        : String?
    var product_id  : String?
    var sku_id      : String?
    var sku_title   : String?
    var imageUrl    : String?
    var sku_price   : String?
    var count       : String?
    var price       : String?
    var total       : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        product_id  <- map["product_id"]
        sku_id      <- map["sku_id"]
        sku_title   <- map["sku_title"]
        sku_price   <- map["sku_price"]
        count       <- map["count"]
        price       <- map["price"]
        total       <- map["total"]
        imageUrl    <- map["image"]
    }
}