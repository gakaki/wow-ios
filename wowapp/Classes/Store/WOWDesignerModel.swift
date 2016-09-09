//
//  WOWDesignerModel.swift
//  wowapp
//
//  Created by 安永超 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWDesignerModel: WOWBaseModel,Mappable{
    var designerId              : Int?
    var designerName            : String?
    var designerPhoto           = String()
    var designerDesc            : String?
    var designerNameFirstLetter : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        designerId              <- map["id"]
        designerName            <- map["designerName"]
        designerPhoto           <- map["designerPhoto"]
        designerDesc            <- map["designerDesc"]
        designerNameFirstLetter <- map["designerNameFirstLetter"]
    }
}
