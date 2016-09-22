//
//  WOWBuyCarModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

//class WOWBuyCarModel: Object,Mappable{
//    dynamic var skuProductCount:Int        = 1
//    dynamic var skuProductName:String      = ""
//    dynamic var skuProductPrice:String     = ""
//    dynamic var skuProductImageUrl:String  = ""
//    dynamic var skuName:String             = ""
//    dynamic var skuID  :String             = ""
//    dynamic var productID :String          = ""
//    dynamic var skus:[WOWProductSkuModel]  = [WOWProductSkuModel]()
//    
//    override static func primaryKey() -> String? {
//        return "skuID"
//    }
//
//    override static func ignoredProperties() -> [String] {
//        return ["skus"]
//    }
//    
//    
//    func mapping(map: Map) {
//        skuProductCount         <- map["count"]
//        skuProductName          <- map["product_name"]
//        skuProductPrice         <- map["price"]
//        skuProductImageUrl      <- map["product_image"]
//        skuName                 <- map["sku_title"]
//        skuID                   <- map["sku_id"]
//        productID               <- map["id"]
//        skus                    <- map["skus"]
//    }
//    
//    convenience required init?(_ map: Map) {
//        self.init()
//    }
//}
class WOWCarModel: WOWBaseModel,Mappable {
    var totalPrice                          : NSNumber?
    var shoppingCartResult                  : [WOWCarProductModel]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        totalPrice                            <- map["totalPrice"]
        shoppingCartResult                    <- map["shoppingCartResult"]
        
    }
    
}

class WOWCarProductModel: WOWBaseModel,Mappable {
    var parentProductId                     : Int?
    var shoppingCartId                      : Int?
    var productId                           : Int?
    var productName                         : String?
    var sellPrice                           : Double?
    var productQty                          : Int?
    var sellTotalAmount                     : Double?
    var productStock                        : Int?
    var color                               : String?
    var specImg                             : String?
    var productStatus                       : Int?
    var productStatusName                   : String?
    var isSelected                          : Bool?
    var specName                            : String?   //图片地址
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        parentProductId                      <- map["parentProductId"]
        shoppingCartId                       <- map["shoppingCartId"]
        productId                            <- map["productId"]
        productName                          <- map["productName"]
        sellPrice                            <- map["sellPrice"]
        productQty                           <- map["productQty"]
        sellTotalAmount                      <- map["sellTotalAmount"]
        productStock                         <- map["productStock"]
        color                                <- map["color"]
        specImg                              <- map["specImg"]
        productStatus                        <- map["productStatus"]
        productStatusName                    <- map["productStatusName"]
        isSelected                           <- map["isSelected"]
        specName                             <- map["specName"]
    }
    
}


