//
//  WOWEnjoyCategoryModel.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/27.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWEnjoyCategoryModel: WOWBaseModel,Mappable {
    
    var id                      :  Int?
    var categoryName            :  String?
    var isSelect                :  Bool = false

    
    required init?(map: Map) {
        
    }
    init(id: Int, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
    }
    func mapping(map: Map) {
        id                          <- map["id"]
        categoryName                <- map["categoryName"]
        
    }
    
}
