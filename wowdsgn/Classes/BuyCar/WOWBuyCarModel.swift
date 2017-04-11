//
//  WOWBuyCarModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWCarModel: WOWBaseModel,Mappable {
    var totalPrice                          : NSNumber?
    var shoppingCartResult                  : [WOWCarProductModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalPrice                            <- map["totalPrice"]
        shoppingCartResult                    <- map["shoppingCartResult"]
        
    }
    
}

class WOWCarProductModel: WOWBaseModel,Mappable {
    var parentProductId                     : Int?
    var shoppingCartId                      : Int?
    var productId                           : Int?
    var productName                         : String?
    var productTitle                        : String?
    var oldPrcie                            : Double?
    var sellPrice                           : Double?
    var productQty                          : Int?
    var sellTotalAmount                     : Double?
    var productStock                        : Int?
    var color                               : String?
    var specImg                             : String?
    var productStatus                       : Int?
    var productStatusName                   : String?
    var isSelected                          : Bool?
    var isPromotion                         : Bool?
    var specName                            : String?
    var attributes                          : [String]?
    var limitQty                            : Int?
    var pricePromotionTag                   : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        parentProductId                      <- map["parentProductId"]
        shoppingCartId                       <- map["shoppingCartId"]
        productId                            <- map["productId"]
        productName                          <- map["productName"]
        productTitle                         <- map["productTitle"]
        oldPrcie                             <- map["oldPrice"]
        sellPrice                            <- map["sellPrice"]
        productQty                           <- map["productQty"]
        sellTotalAmount                      <- map["sellTotalAmount"]
        productStock                         <- map["productStock"]
        color                                <- map["color"]
        specImg                              <- map["specImg"]
        productStatus                        <- map["productStatus"]
        productStatusName                    <- map["productStatusName"]
        isSelected                           <- map["isSelected"]
        isPromotion                          <- map["isPromotion"]
        specName                             <- map["specName"]
        attributes                           <- map["attributes"]
        limitQty                             <- map["limitQty"]
        pricePromotionTag                    <- map["pricePromotionTag"]
    }
    
}


