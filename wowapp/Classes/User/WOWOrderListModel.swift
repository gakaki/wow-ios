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
    var transCompany    : String? //物流公司
    var transNumber     : String? //物流单号
    
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
        transCompany        <- map["transCompany"]
        transNumber         <- map["transNumber"]
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
class WOWNewOrderListModel: WOWBaseModel,Mappable{
    var orderId              : Int? // 订单Id
    
    var orderCode       : String?// 订单编号
    
    var orderAmount     : Double?// 订单金额
    
    var orderStatus     : Int?// 订单状态
    
    var orderStatusName : String?//订单状态名称
    
    var totalProductQty : Int?// 订单产品总件数
    
    var productSpecImgs : Array<String> = [] // 产品规格图片列表
    
    var orderCreateTimeFormat : String? // 订单创建的时间
    
    
    
    required init?(_ map: Map) {
        
        
        
    }
    
    
    
    func mapping(map: Map) {
        
        orderId                  <- map["orderId"]
        
        orderCode            <- map["orderCode"]
        
        orderAmount              <- map["orderAmount"]
        
        orderStatus          <- map["orderStatus"]
        
        orderStatusName               <- map["orderStatusName"]
        
        totalProductQty        <- map["totalProductQty"]
        
        productSpecImgs          <- map["productSpecImgs"]
        
        orderCreateTimeFormat    <- map["orderCreateTimeFormat"]
        
    }
}
/// 已经发货MOdel
class WOWNewForGoodsModel: WOWBaseModel,Mappable{
    
    var deliveryCompanyName              : String? //快递公司名称
    
    var deliveryOrderNo       : String?// 快递单号

    
    var productArray : [WOWNewProductModel]? // 产品列表
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        deliveryCompanyName                  <- map["deliveryCompanyName"]
        
        deliveryOrderNo            <- map["deliveryOrderNo"]
        
        productArray              <- map["productArray"]
        
    }
}
/// 产品model
class WOWNewProductModel: WOWBaseModel,Mappable{
    
    var productId              : Int? //产品id
    
    var productName       : String?// 产品名称
    
    var sellPrice     : Double?// 产品销售价格
    
    var productQty     : Int?// 产品数量
    
    var sellTotalAmount : Double?//产品销售价乘以数量
    
    var color : String?// 产品颜色
    
    //    var productSpecImgs : Array<String> = [] // 产品规格图片列表
    
    var specImg : String? // 规格图片
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        productId                  <- map["productId"]
        
        productName            <- map["productName"]
        
        sellTotalAmount              <- map["sellTotalAmount"]
        
        color          <- map["color"]
        
        specImg               <- map["specImg"]
        
        sellPrice          <- map["sellPrice"]
        
        productQty    <- map["productQty"]
        
    }
}
