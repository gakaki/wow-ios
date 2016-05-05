//
//  WOWBrandListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWBrandListModel: WOWBaseModel,Mappable {
    var brandImageUrl:String?
    var brandName:String?
    var brandCountry:String?
    var brandID:String?
    
    //brand des
    var brandDesc:String?
    
    
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }

    
    func mapping(map: Map) {
        brandImageUrl   <- map["brand_image"]
        brandName       <- map["brand_name"]
        brandID         <- map["brand_id"]
        brandDesc       <- map["brand_desc"]
    }
}
