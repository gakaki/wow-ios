//
//  WOWBrandModel.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWBrandStyleModel: WOWBaseModel,Mappable {
    
    var id                  :   Int?
    var brandCname          :   String?
    var brandEname          :   String?
    var brandLogoImg        :   String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        brandCname              <- map["brandCname"]
        brandEname              <- map["brandEname"]
        brandLogoImg            <- map["brandLogoImg"]
    
    }

}
