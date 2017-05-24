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
    
    var paymentStatus                       : Int?// 支付状态
    var paymentStatusName                   : String?// 支付状态名称
    var paymentMethod                       : Int?//支付方式
    var paymentMethodName                   : String?//支付方式名称
    var totalProductQty                     : Int?//购买的商品总件数
    var packages                            : [WOWNewForGoodsModel]?//已发货清单列表
    var unShipOutOrderItems                 : [WOWNewProductModel]?//未发货清单列表
    var orderItemVos                        : [WOWNewProductModel]?// 退换货清单
    var productAmount                       : String?//退款金额
    var leftPaySeconds                      : Int? // 订单剩余支付时间
    
    var changedAmount                        : Double?        //商家修改金额
    var changedAmountType                    : Int?             //商家改价类型 1 减价 2 加价
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
        changedAmount                       <- map["changedAmount"]
        changedAmountType                   <- map["changedAmountType"]
        
        orderItemVos                        <- map["orderItemVos"]
        productAmount                       <- map["productAmount"]
    }
}

/// 已经发货MOdel
class WOWNewForGoodsModel: WOWBaseModel,Mappable{
    
    var deliveryCompanyName                 : String? //快递公司名称
    
    var deliveryOrderNo                     : String?// 快递单号
    
    var deliveryCompanyCode                 : String? //快递公司编码
    
    var orderItems                          : [WOWNewProductModel]? // 产品列表
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        deliveryCompanyName                         <- map["deliveryCompanyName"]
        
        deliveryCompanyCode                         <- map["deliveryCompanyCode"]
        
        deliveryOrderNo                             <- map["deliveryOrderNo"]
        
        orderItems                                  <- map["orderItems"]
        
    }
}
/// 产品model
class WOWNewProductModel: WOWBaseModel,Mappable{
    
    var productId                                           : Int? //产品id
    var productName                                         : String?// 产品名称
    var productQty                                          : Int?// 产品数量
    var parentProductId                                     : Int?// 当前产品的Id
    var color                                               : String?// 产品颜色
    var specImg                                             : String? // 规格图片
    var sellPrice                                           : Double?// 产品销售价格
    var saleOrderItemId                                     : Int?// 销售订单单项Id
    var sellTotalAmount                                     : Double?//产品销售价乘以数量
    var specName                                            : String?// 产品规格大小
    var productTotalAmount                                  : Double?// 产品总金额
    var attributes                                          : [String]?
    var isRefund                                            : Bool?
    var isDeliveryed                                        : Bool? // 标记是否已经发货
    var isRefundAvailable                                   : Bool? // 是否可以申请售后
    var saleOrderItemRefundId                               : Int?   //退换货服务 ID
    var refundStatusName                                    : String?// 退换货进度名称
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
        isRefund                            <- map["isRefund"]
        isDeliveryed                        <- map["isDeliveryed"]
        isRefundAvailable                   <- map["isRefundAvailable"]
        saleOrderItemRefundId               <- map["saleOrderItemRefundId"]
        refundStatusName                    <- map["refundStatusName"]
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
// 退换货详情 model
class WOWRefundDetailModel: WOWBaseModel,Mappable{
    
    var refundAmount                                : Double?           // 退款金额
    var refundRemark                                : String?           // 退款说明
    var refundType                                  : Int?              // 退款类型
    var refundTypeName                              : String?           // 退款类型名称
    var received                                    : Bool?             // 是否已经收到货
    var refundReason                                : Int?              // 退换货理由Id
    var serviceCode                                 : String?           // 服务单号
    var serviceCreateTime                           : String?           // 创建时间
    var saleOrderItemRefundId                       : Int?              // 退换货ID
    var refundStatus                                : Int?              // 退换货进度
    var refundStatusName                            : String?           // 退换货进度名称
    var returnAddress                               : String?           // 退换地址
    var refundReceiveName                           : String?           // 退换地址 名字
    var refundReceivePhone                          : String?           // 退换地址 手机号
    var maxRefundableTime                           : String?           // 最晚寄回货物时间
    var returnLogisticsCode                         : String?           // 物流单号
    var returnDeliveryCompanyName                   : String?           // 物流公司名称
    var actualRefundAmount                          : Double?           // 实际退款金额
    var refundSuccessTime                           : String?           // 退款金额时间
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        refundAmount                                    <- map["refundAmount"]
        refundRemark                                    <- map["refundRemark"]
        refundType                                      <- map["refundType"]
        refundTypeName                                  <- map["refundTypeName"]
        received                                        <- map["received"]
        refundReason                                    <- map["refundReason"]
        serviceCode                                     <- map["serviceCode"]
        serviceCreateTime                               <- map["serviceCreateTime"]
        saleOrderItemRefundId                           <- map["saleOrderItemRefundId"]
        refundStatus                                    <- map["refundStatus"]
        refundStatusName                                <- map["refundStatusName"]
        returnAddress                                   <- map["returnAddress"]
        refundReceiveName                               <- map["refundReceiveName"]
        refundReceivePhone                              <- map["refundReceivePhone"]
        maxRefundableTime                               <- map["maxRefundableTime"]
        returnLogisticsCode                             <- map["returnLogisticsCode"]
        returnDeliveryCompanyName                       <- map["returnDeliveryCompanyName"]
        actualRefundAmount                              <- map["actualRefundAmount"]
        refundSuccessTime                               <- map["refundSuccessTime"]
    }
}

//  退换货服务  参数Model  获取最大退款金额
class WOWRefundTypeModel: WOWBaseModel,Mappable{
    
    var deliveryFee                                 : String?                           // 邮费金额
    var maxAllowedRefundAmount                      : String?                           // 最大退款金额
    var orderDetailResultVo                         : WOWNewOrderDetailModel?           // 退款订单列表

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        deliveryFee                                                 <- map["deliveryFee"]
        maxAllowedRefundAmount                                      <- map["maxAllowedRefundAmount"]
        orderDetailResultVo                                         <- map["orderDetailResultVo"]
    }
    
}

//  退换协商详情
class WOWRufundDiscussModel: WOWBaseModel,Mappable{
    
    var createTime                                  : String?                           // 创建的时间
    var remark                                      : String?                           // 内容
    var operatorContent                             : String?                           // 标题
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        createTime                                                  <- map["createTime"]
        remark                                                      <- map["remark"]
        operatorContent                                             <- map["operatorContent"]
    }
    
}

//  钱款去向model
class WOWRufundProcessModel: WOWBaseModel,Mappable{
    
    var refundEventType                                         : Int?           // 流转事件类型
    var refundEventTypeName                                     : String?           // 流转事件类型名称
    var createTime                                              : String?           // 创建时间
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        refundEventType                                                     <- map["refundEventType"]
        refundEventTypeName                                                 <- map["refundEventTypeName"]
        createTime                                                          <- map["createTime"]
    }
    
}
// 退换列表 Model
class WOWRefundListModel: WOWBaseModel,Mappable{
    

    var productId                                   : Int?           // 退换地址 名字
    var productName                                 : String?           // 退换地址 手机号
    
    var refundAmount                                : Double?           // 退款金额
    var refundItemQty                               : Int?              // 退款类型
    var refundStatus                                : Int?              // 退换货进度
    var refundStatusName                            : String?           // 退换货进度名称
    var refundType                                  : Int?              // 退款类型
    var refundTypeName                              : String?           // 退款类型名称
    var saleOrderItemRefundId                       : Int?              // 退换货ID
    var serviceCode                                 : String?           // 服务单号
    var specImg                                     : String?           // 退款说明
    var attributes                                  : [String]?
    var actualRefundAmount                          : Double?           // 实际退款金额
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productId                                       <- map["productId"]
        productName                                     <- map["productName"]
        
        refundType                                      <- map["refundType"]
        refundTypeName                                  <- map["refundTypeName"]
    
        refundAmount                                    <- map["refundAmount"]
        
        attributes                                      <- map["attributes"]

        refundItemQty                                   <- map["refundItemQty"]
        
        specImg                                         <- map["specImg"]

        serviceCode                                     <- map["serviceCode"]

        saleOrderItemRefundId                           <- map["saleOrderItemRefundId"]
        refundStatus                                    <- map["refundStatus"]
        refundStatusName                                <- map["refundStatusName"]
        actualRefundAmount                              <- map["actualRefundAmount"]
    }
    
}

