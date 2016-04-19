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
    var imageUrl:String?
    var brandName:String?
    var brandCountry:String?
    var brandID:String?
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }

    
    func mapping(map: Map) {
        imageUrl    <- map["pic"]
        brandName   <- map["name"]
        brandID     <- map["id"]
    }
}
