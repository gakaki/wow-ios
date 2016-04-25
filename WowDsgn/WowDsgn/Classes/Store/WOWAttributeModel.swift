//
//  WOWAttributeModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWAttributeModel: WOWBaseModel,Mappable{
    
    var code        :String?
    var title       :String?
    var value       :String?
    var attriImage  :String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        code        <- map["key"]
        value       <- map["value"]
        title       <- map["label"]
        attriImage  <- map["pic_app"]
    }
}


class WOWProductPicTextModel:WOWBaseModel,Mappable {
    var image  :String?
    var text    :String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        text  <- map["text"]
    }
}


class WOWProductSkuModel: WOWBaseModel,Mappable {
    var skuID       : String?
    var skuTitle    : String?
    var skuPrice    : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        skuID       <- map["sku"]
        skuTitle    <- map["title"]
        skuPrice    <- map["price"]
    }
}