//
//  WOWProductSpecModel.swift
//  wowapp
//
//  Created by 安永超 on 16/7/29.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper


class WOWProductSpecModel: WOWBaseModel,Mappable {
    var products                     : [WOWProductModel]?
    var serialAttribute             : [WOWSerialAttributeModel]?
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        products                         <- map["products"]
        serialAttribute             <- map["attributes"]
    }
}



class WOWSerialAttributeModel: WOWBaseModel, Mappable {
    var attributeId                 : Int?
    var attributeName               : String?
    var attributeShowName           : String?
    var attributeValues             : Array<String>?
    var attributeValue              : String?
    var specName                    = [WOWSpecNameModel]()
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        attributeId                   <- map["attributeId"]
        attributeName                 <- map["attributeName"]
        attributeShowName             <- map["attributeShowName"]
        attributeValues               <- map["attributeValues"]
        attributeValue                <- map["attributeValue"]
        if let attri = attributeValues{
            for a in attri {
                let model = WOWSpecNameModel(specName: a, isSelect: false, isCanSelect: true)
                specName.append(model)
            }
            
        }
    }
    
}




class WOWSpecNameModel: WOWBaseModel {
    var specName                           : String
    var isSelect                           : Bool
    var isCanSelect                        : Bool
    init(specName: String, isSelect: Bool, isCanSelect: Bool) {
        self.specName = specName
        self.isSelect = isSelect
        self.isCanSelect = isCanSelect
    }
    
}

