//
//  WOWActivityModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWActivityModel:NSObject,Mappable{
    var image   : String?
    var url     : String?
    

    required init?(_ map: Map) {
        
    }
    
    
    
    func mapping(map: Map) {
        image <-  map["image"]
        url   <-  map["url"]
    }
}
