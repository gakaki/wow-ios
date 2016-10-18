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
    var productId                   : String?
    var productName                 : String?
    var sizeText                    : String?
    var colorDisplayNameList        : Array<String>?
    var specNameList                : Array<String>?
    var colorSpecVoList             : [WOWColorSpecModel]?
    var specColorVoList             : [WOWSpecColorModel]?
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        productId                   <- map["productId"]
        productName                 <- map["productName"]
        sizeText                    <- map["sizeText"]
        colorDisplayNameList        <- map["colorDisplayNameList"]
        specNameList                <- map["specNameList"]
        colorSpecVoList             <- map["colorSpecVoList"]
        specColorVoList             <- map["specColorVoList"]
        
    }
}
class WOWColorNameModel: WOWBaseModel {
    var colorDisplayName                   : String
    var isSelect                           : Bool
     init(colorDisplayName: String,isSelect: Bool) {
        self.colorDisplayName = colorDisplayName
        self.isSelect = isSelect
    }
    
}

class WOWSpecNameModel: WOWBaseModel {
    var specName                           : String
    var isSelect                           : Bool
    init(specName: String,isSelect: Bool) {
        self.specName = specName
        self.isSelect = isSelect
    }
    
}

class WOWColorSpecModel: WOWBaseModel,Mappable {
    var colorDisplayName                   : String?
    var specMapVoList                      : [WOWSpecModel]?
    
    required
    init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        colorDisplayName                   <- map["colorDisplayName"]
        specMapVoList                      <- map["specMapVoList"]
        
    }

}
class WOWSpecModel: WOWBaseModel,Mappable {
    var specName                            : String?
    var subProductInfo                      : WOWProductInfoModel?
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        specName                            <- map["specName"]
        subProductInfo                      <- map["subProductInfo"]
        
    }
    
}
class WOWProductInfoModel: WOWBaseModel,Mappable {
    var subProductId                        : Int?
    var productColorImg                     : String?
    var sizeText                            : String?
    var weight                              : Int?
    var sellPrice                           : Double?
    var availableStock                      : Int?
    var hasStock                            : Bool?
    var productQty                          : Int?
    var productName                         : String?
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        subProductId                        <- map["subProductId"]
        productColorImg                     <- map["productColorImg"]
        sizeText                            <- map["sizeText"]
        weight                              <- map["weight"]
        sellPrice                           <- map["sellPrice"]
        availableStock                      <- map["availableStock"]
        hasStock                            <- map["hasStock"]

        
        productName                         <- map["productName"]

    }
    
}
class WOWSpecColorModel: WOWBaseModel,Mappable {
    var specName                            : String?
    var colorMapVoList                      : [WOWColorModel]?
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        specName                            <- map["specName"]
        colorMapVoList                      <- map["colorMapVoList"]
        
    }
    
}
class WOWColorModel: WOWBaseModel,Mappable {
    var colorDisplayName                    : String?
    var subProductInfo                      : WOWProductInfoModel?
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        colorDisplayName                    <- map["colorDisplayName"]
        subProductInfo                      <- map["subProductInfo"]
        
    }
    
}
