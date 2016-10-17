//
//  WOWEditOrderModel.swift
//  wowapp
//
//  Created by 安永超 on 16/8/4.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWEditOrderModel: WOWBaseModel,Mappable {
    var deliveryFee                          : Double?
    var totalAmount                          : Double?
    var productTotalAmount                   : Double?
    var orderSettles                         : [WOWCarProductModel]?
    var endUserCouponId                      : Int?
    var deduction                            : Double?
    var avaliableCouponCount                 : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        deliveryFee                          <- map["deliveryFee"]
        totalAmount                         <- map["totalAmount"]
        orderSettles                         <- map["orderSettles"]
        productTotalAmount                   <- map["productTotalAmount"]
        endUserCouponId                     <- map["endUserCouponId"]
        deduction                           <- map["deduction"]
        avaliableCouponCount                <- map["avaliableCouponCount"]
    }
    
}
