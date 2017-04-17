//
//  WOWCustomerInfoModel.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/4/17.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWCustomerInfoModel: WOWBaseModel,  Mappable {
    

    var key           : String = ""
    var label         : String = ""
    var value         : String = ""
    var hidden        : Bool = false
    required init?(map: Map) {
        
    }
    init(key: String, label: String, value: String,isHidden:Bool = false) {

        self.key = key
        self.label = label
        self.value = value
        self.hidden = isHidden
    }
    // Mappable
    func mapping(map: Map) {
        key             <- map["key"]
        label           <- map["label"]
        value           <- map["value"]
        hidden          <- map["hidden"]
    }
}
