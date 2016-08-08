//
//  WOWAddressListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/28.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWAddressListModel: WOWBaseModel,Mappable{
    var name            : String?
    var city            : String?
    var county          : String?
    var district        : String?
    var street          : String?
    var province        : String?
    var mobile          : String?
    var addressDetail   : String?
    var isDefault       : Bool?
    var id              : Int?
    var provinceId      : Int?
    var cityId          : Int?
    var countyId        : Int?
    
    override init() {
        super.init()
    }

    
    required init?(_ map: Map) {

        
    }
    
     func mapping(map: Map) {
        name            <- map["receiverName"]
        cityId          <- map["cityId"]
        district        <- map["district"]
        street          <- map["street"]
        provinceId      <- map["provinceId"]
        mobile          <- map["receiverMobile"]
        isDefault       <- map["isDefault"]
        id              <- map["id"]
        addressDetail   <- map["addressDetail"]
        countyId        <- map["countyId"]
        province        <- map["provinceName"]
        city            <- map["cityName"]
        county          <- map["countyName"]
    }
}
