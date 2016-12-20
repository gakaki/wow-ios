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
    
    required init?(map: Map) {
        
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
    
    required init?(map: Map) {
        
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
/// 订单列表新model
class WOWNewOrderListModel: WOWBaseModel,Mappable{
    var orderId              : Int? // 订单Id
    
    var orderCode       : String?// 订单编号
    
    var orderAmount     : Double?// 订单金额
    
    var orderStatus     : Int?// 订单状态
    
    var orderStatusName : String?//订单状态名称
    
    var totalProductQty : Int?// 订单产品总件数
    
    var productSpecImgs : Array<String> = [] // 产品规格图片列表
    
    var orderCreateTimeFormat : String? // 订单创建的时间
    var isComment       :Bool?
    
    
    required init?(map: Map) {
        
        
        
    }
    
    
    
    func mapping(map: Map) {
        
        orderId                  <- map["orderId"]
        
        orderCode               <- map["orderCode"]
        
        orderAmount              <- map["orderAmount"]
        
        orderStatus             <- map["orderStatus"]
        
        orderStatusName               <- map["orderStatusName"]
        
        totalProductQty        <- map["totalProductQty"]
        
        productSpecImgs          <- map["productSpecImgs"]
        
        orderCreateTimeFormat    <- map["orderCreateTimeFormat"]
        
        isComment               <- map["isComment"]
    }
}
/// 订单详情MOdel
class WOWNewOrderDetailModel: WOWBaseModel,Mappable{
    
    var couponAmount                : Double? //订单优惠金额
    
    var deliveryFee                 : Double?// 订单运费
    
    var orderAmount                 : Double?// 订单总金额
    var orderCode                   : String?// 订单号
    var orderCreateTimeFormat                 : String?// 订单下单时间
    var orderId                     : Int?      // 订单Id
    var orderStatus                 : Int?      // 订单状态
    var orderStatusName             : String?   // 订单状态名称
    var receiverName                : String?   // 收货人姓名
    var receiverMobile              : String?   // 收货人手机
    var receiverAddress             : String?   // 收货人地址
    var isComment                   : Bool?     // 待评论
    
    var paymentStatus                 : Int?// 支付状态
    var paymentStatusName                 : String?// 支付状态名称
    var paymentMethod                 : Int?//支付方式
    var paymentMethodName                 : String?//支付方式名称
    var totalProductQty                 : Int?//购买的商品总件数
    var packages                        : [WOWNewForGoodsModel]?//已发货清单列表
    var unShipOutOrderItems                 : [WOWNewProductModel]?//未发货清单列表
    
    var leftPaySeconds              : Int? // 订单剩余支付时间
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        couponAmount                        <- map["couponAmount"]
        deliveryFee                         <- map["deliveryFee"]
        orderAmount                         <- map["orderAmount"]
        orderCode                           <- map["orderCode"]
        orderCreateTimeFormat               <- map["orderCreateTimeFormat"]
        orderId                             <- map["orderId"]
        orderStatus                         <- map["orderStatus"]
        orderStatusName                     <- map["orderStatusName"]
        
        receiverName                        <- map["receiverName"]
        receiverMobile                      <- map["receiverMobile"]
        receiverAddress                     <- map["receiverAddress"]
         isComment                          <- map["isComment"]
        paymentStatus                       <- map["paymentStatus"]
        paymentStatusName                   <- map["paymentStatusName"]
        paymentMethod                       <- map["paymentMethod"]
        paymentMethodName                   <- map["paymentMethodName"]
        totalProductQty                     <- map["totalProductQty"]
        packages                            <- map["packages"]
        unShipOutOrderItems                 <- map["unShipOutOrderItems"]
        leftPaySeconds                      <- map["leftPaySeconds"]
    }
}

/// 已经发货MOdel
class WOWNewForGoodsModel: WOWBaseModel,Mappable{
    
    var deliveryCompanyName              : String? //快递公司名称
    
    var deliveryOrderNo       : String?// 快递单号
    
    var deliveryCompanyCode              : String? //快递公司编码
    
    var orderItems : [WOWNewProductModel]? // 产品列表
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        deliveryCompanyName                  <- map["deliveryCompanyName"]
        
        deliveryCompanyCode                  <- map["deliveryCompanyCode"]
        
        deliveryOrderNo            <- map["deliveryOrderNo"]
        
        orderItems              <- map["orderItems"]
        
    }
}
/// 产品model
class WOWNewProductModel: WOWBaseModel,Mappable{
    var productId              : Int? //产品id
    var productName             : String?// 产品名称
    var productQty     : Int?// 产品数量
    var parentProductId     : Int?// 当前产品的Id
    var color : String?// 产品颜色
    
    var specImg : String? // 规格图片
    
    var sellPrice     : Double?// 产品销售价格
    var saleOrderItemId     : Int?// 销售订单单项Id
    var sellTotalAmount : Double?//产品销售价乘以数量
    
    var specName             : String?// 产品规格大小
    
    var productTotalAmount             : Double?// 产品总金额
    var attributes                          : [String]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productId                           <- map["productId"]
        productName                         <- map["productName"]
        sellTotalAmount                     <- map["sellTotalAmount"]
        color                               <- map["color"]
        specImg                             <- map["specImg"]
        sellPrice                           <- map["sellPrice"]
        productQty                          <- map["productQty"]
        saleOrderItemId                     <- map["saleOrderItemId"]
        specName                            <- map["specName"]
        parentProductId                     <- map["parentProductId"]
        productTotalAmount                  <- map["productTotalAmount"]
        attributes                          <- map["attributes"]
    }
}
// 商品评论model
class WOWProductPushCommentModel: WOWBaseModel,Mappable{
    
    var productId                       : Int?          // 当前产品id
    var saleOrderItemId                 : Int?          // 当前订单下的Id
    var productName                     : String?       // 产品姓名
    var specAttribute                   : [String]?     // 产品描述数组
    var productImg                      : String?       // 产品图片
    

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productId                               <- map["productId"]
        saleOrderItemId                         <- map["saleOrderItemId"]
        productName                             <- map["productName"]
        specAttribute                           <- map["specAttribute"]
        productImg                              <- map["productImg"]
    }
    
}
