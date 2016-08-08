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
    var brandLogoImg    :String?
    var brandCName      :String?
    var brandId         :Int?
    
    //brand des
    var brandDesc       :String?
    
    
    
    required init?(_ map: Map) {
        
    }
    
    override init() {
        
    }

    
    func mapping(map: Map) {
        brandLogoImg    <- map["brandLogoImg"]
        brandCName      <- map["brandCName"]
        brandId         <- map["brandId"]
        brandDesc       <- map["brandDesc"]
    }
}
