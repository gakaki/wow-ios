//
//  WOWBannerModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWBannerModel:NSObject,Mappable{
    var imageUrl : String?
    var url      : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        imageUrl  <-   map["image"]
        url       <-   map["url"]
    }
}
