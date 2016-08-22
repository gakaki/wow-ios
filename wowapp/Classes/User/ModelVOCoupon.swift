

import UIKit
import ObjectMapper
//
//{
//    "id": 1,
//    "couponType": 2,
//    "couponTitle": "满100减20",
//    "couponDesc": "满100减20",
//    "couponLimitType": 0,
//    "discountRate": null,
//    "deduction": 20,
//    "minAmountLimit": 100,
//    "effectiveFrom": "2016-08-16",
//    "effectiveTo": "2016-09-16",
//    "expired": false,
//    "return": null,
//    "used": false
//}
class WOWCouponModel: WOWBaseModel,Mappable {
    var id : Int?
    var couponType: Int?
    var couponTitle: String?
    var couponDesc: String?
    var couponLimitType: Int?
    var discountRate: String?
    var deduction: Double?
    var minAmountLimit: Int?
    var effectiveFrom : String?
    var effectiveTo: String?
    var expired: Bool = false
    var return_str: String?
    var used: Bool = false
    var canUsed: Bool?
    var isSelect: Bool = false
    
    
    var status: Int?
    var statusDesc: String?

    
    override init() {
        super.init()
    }
    required init?(_ map: Map) {
        
        
    }

    func mapping(map: Map) {
        id                      <- map["id"]
        couponType              <- map["couponType"]
        couponTitle             <- map["couponTitle"]
        couponDesc              <- map["couponDesc"]
        couponLimitType         <- map["couponLimitType"]
        discountRate            <- map["discountRate"]
        deduction               <- map["deduction"]
        minAmountLimit          <- map["minAmountLimit"]
        effectiveFrom           <- map["effectiveFrom"]
        effectiveTo             <- map["effectiveTo"]
        expired                 <- map["expired"]
        return_str              <- map["return"]
        used                    <- map["used"]
        canUsed                 <- map["canUsed"]
        
        status                  <- map["status"]
        statusDesc              <- map["statusDesc"]
    }
}

