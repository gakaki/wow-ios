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

class WOWParameter: WOWBaseModel,Mappable{
    
    var materialText        :String?
    var needAssemble        :Bool?
    var origin              :String?
    var style               :String?
    var applicableSceneText :String?
    var applicablePeople    :String?
    var sizeText            :String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        materialText            <- map["materialText"]
        needAssemble            <- map["needAssemble"]
        origin                  <- map["origin"]
        style                   <- map["style"]
        applicableSceneText     <- map["applicableSceneText"]
        applicablePeople        <- map["applicablePeople"]
        sizeText                <- map["sizeText"]
    }
}


class WOWProductPicTextModel:WOWBaseModel,Mappable {
    var image  :String?
    var text    :String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["url"]
        text  <- map["desc"]
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