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
    
    var key     :String?
    var value   :String?
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        key     <- map["key"]
        value   <- map["value"]
        
    }
}
