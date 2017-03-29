//
//  WOWFineWroksModel.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/29.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWFineWroksModel: WOWBaseModel,Mappable {
    
    var id                              :  Int?
    var measurement                     :  Int?
    var categoryName                    :  String?
    var des                             :  String?
    var instagramCategoryId             :  Int?
    var collectCounts                   :  Int?
    var likeCounts                      :  Int?
    var pic                             :  String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                                                      <- map["id"]
        measurement                                             <- map["measurement"]
        instagramCategoryId                                     <- map["instagramCategoryId"]
        categoryName                                            <- map["categoryName"]
        des                                                     <- map["description"]
        collectCounts                                           <- map["collectCounts"]
        likeCounts                                              <- map["likeCounts"]
        pic                                                     <- map["pic"]
        
    }

}
