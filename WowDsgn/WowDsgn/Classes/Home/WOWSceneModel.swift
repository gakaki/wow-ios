//
//  WOWSceneModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWSenceModel: WOWBaseModel,Mappable{
    var senceID          :   String?
    var senceName        :   String?
    var senceProducts    :   [WOWProductModel]?
    var senceTime        :   String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        senceID         <- map["id"]
        senceName       <- map["name"]
        senceTime       <- map["time"]
        senceProducts   <- map["products"]
    }
}
