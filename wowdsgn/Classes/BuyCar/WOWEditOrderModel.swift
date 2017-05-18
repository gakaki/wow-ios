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
    var deliveryFee                          : Double?  //运费
    var totalAmount                          : Double?  //结算总金额
    var productTotalAmount                   : Double?    //产品总金额
    var orderSettles                         : [WOWCarProductModel]?    //订单信息
    var endUserCouponId                      : Int?         //优惠券id
    var deduction                            : Double?    //优惠券优惠金额
    var avaliableCouponCount                 : Int?         //可用优惠券数量
    
    /**************************V2增加字段*****************************/
    var deductionName                        : String?      //优惠券名字
    var deliveryFeeThreshold                 : Double?      //最低免运费金额
    var deliveryStandard                     : Double?          //运费金额
    var promotionNames                       : [String]?         //促销活动的名字
    var promotionProductInfoVos              : [WOWPromotionProductInfoModel]?   //促销信息
    var totalPromotionDeduction              : Double?          //促销优惠金额
    
    /**************************V3增加字段*****************************/
    var overseaOrder                         : Bool?            //是否海购
    //额外字段
    var remark                               : String?          //买家备注
    var isPromotion                          : Bool = true            //是否使用促销
    var discountAmount                       : Double = 0                  //优惠金额
    
    override init() {
        super.init()
    }
    
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
        
        deductionName                          <- map["deductionName"]
        deliveryFeeThreshold                         <- map["deliveryFeeThreshold"]
        deliveryStandard                         <- map["deliveryStandard"]
        promotionNames                          <- map["promotionNames"]
        promotionProductInfoVos                   <- map["promotionProductInfoVos"]
        totalPromotionDeduction                     <- map["totalPromotionDeduction"]
        //如果优惠金额 = 0 ，说明没有优惠
        //默认选促销
        if totalPromotionDeduction == 0 {
            isPromotion = false
            discountAmount = deduction ?? 0
        }else {
            isPromotion = true
            discountAmount = totalPromotionDeduction ?? 0
        
        }

    }
    
}

class WOWPromotionProductInfoModel: WOWBaseModel,Mappable {
    var promotionId                          : Int?  //促销活动id
    var productNames                          : [String]?  //参加促销产品名字
    var promotionName                           : String?    //促销名字

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        promotionId                          <- map["promotionId"]
        productNames                         <- map["productNames"]
        promotionName                         <- map["promotionName"]
       
    }
    
}
