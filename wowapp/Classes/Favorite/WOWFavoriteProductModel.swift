//
//  WOWFavoriteProductModel.swift
//  wowapp
//
//  Created by 安永超 on 16/8/5.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWFavoriteProductModel: WOWBaseModel, Mappable {
    
    var productId                          : Int?
    var productImg                         : String?
    var productName                        : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        productId                          <- map["productId"]
        productImg                         <- map["productImg"]
        productName                        <- map["productName"]
        
    }

}

class WOWFavoriteDesignerModel: WOWBaseModel,Mappable{
    var designerId        : Int?
    var designerName      : String?
    var designerPhoto     = String()
    var designerDesc      : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        designerId              <- map["designerId"]
        designerName            <- map["designerName"]
        designerPhoto           <- map["designerPhoto"]
        designerDesc            <- map["designerDesc"]
    }
}
