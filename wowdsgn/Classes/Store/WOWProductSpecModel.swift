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

//class WOWProductSkuModel: WOWBaseModel, Mappable {
//    var productId                   : Int?
//    var parentProductId             : Int?
//    var productTitle                : String?
//    var productImg                  : String?
//    var productStatus               : Int?
//    var productCode                 : String?
//    var sellPrice                   : Double?
//    var originalPrice               : Double?
//    var length                      : Double?
//    var width                       : Double?
//    var height                      : Double?
//    var netWeight                   : Double?
//
//    var attributes                  : [WOWSerialAttributeModel]?
//    var availableStock              : Int?
//    var hasStock                    : Bool?
//    var isNewArrival                : Bool?
//    var productQty                  : Int?
//
//    required init?( map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        productId                   <- map["productId"]
//        parentProductId                 <- map["parentProductId"]
//        productTitle                <- map["productTitle"]
//        productImg                  <- map["productImg"]
//        productStatus               <- map["productStatus"]
//        productCode                 <- map["productCode"]
//        originalPrice               <- map["originalPrice"]
//        length                      <- map["length"]
//        width                       <- map["width"]
//        height                      <- map["height"]
//        netWeight                   <- map["netWeight"]
//        attributes                  <- map["attributes"]
//        sellPrice                   <- map["sellPrice"]
//        availableStock              <- map["availableStock"]
//        hasStock                    <- map["hasStock"]
//        isNewArrival                <- map["isNewArrival"]
//        
//    }
//    
//}



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





//class WOWColorNameModel: WOWBaseModel {
//    var colorDisplayName                   : String
//    var isSelect                           : Bool
//    init(colorDisplayName: String,isSelect: Bool) {
//        self.colorDisplayName = colorDisplayName
//        self.isSelect = isSelect
//    }
//    
//}
//
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
//
//class WOWColorSpecModel: WOWBaseModel,Mappable {
//    var colorDisplayName                   : String?
//    var specMapVoList                      : [WOWSpecModel]?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        colorDisplayName                   <- map["colorDisplayName"]
//        specMapVoList                      <- map["specMapVoList"]
//        
//    }
//    
//}
//class WOWSpecModel: WOWBaseModel,Mappable {
//    var specName                            : String?
//    var subProductInfo                      : WOWProductInfoModel?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        specName                            <- map["specName"]
//        subProductInfo                      <- map["subProductInfo"]
//        
//    }
//    
//}
//class WOWProductInfoModel: WOWBaseModel,Mappable {
//    var subProductId                        : Int?
//    var productColorImg                     : String?
//    var sizeText                            : String?
//    var weight                              : Int?
//    var sellPrice                           : Double?
//    var availableStock                      : Int?
//    var hasStock                            : Bool?
//    var productQty                          : Int?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        subProductId                        <- map["subProductId"]
//        productColorImg                     <- map["productColorImg"]
//        sizeText                            <- map["sizeText"]
//        weight                              <- map["weight"]
//        sellPrice                           <- map["sellPrice"]
//        availableStock                      <- map["availableStock"]
//        hasStock                            <- map["hasStock"]
//        
//    }
//    
//}
//class WOWSpecColorModel: WOWBaseModel,Mappable {
//    var specName                            : String?
//    var colorMapVoList                      : [WOWColorModel]?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        specName                            <- map["specName"]
//        colorMapVoList                      <- map["colorMapVoList"]
//        
//    }
//    
//}
//class WOWColorModel: WOWBaseModel,Mappable {
//    var colorDisplayName                    : String?
//    var subProductInfo                      : WOWProductInfoModel?
//    
//    required init?(map: Map) {
//        
//        
//    }
//    
//    func mapping(map: Map) {
//        colorDisplayName                    <- map["colorDisplayName"]
//        subProductInfo                      <- map["subProductInfo"]
//        
//    }
//    
//}
