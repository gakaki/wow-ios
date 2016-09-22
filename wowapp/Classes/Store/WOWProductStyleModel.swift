//
//  WOWProductStyleModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/20.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

///列表的风格model

class WOWProductStyleModel: Object,Mappable{
   dynamic var styleName   :   String = ""
   dynamic var styleValue  :   String = ""
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    
     func mapping(_ map: Map) {
        styleName   <- map["name"]
        styleValue  <- map["value"]
    }
}
