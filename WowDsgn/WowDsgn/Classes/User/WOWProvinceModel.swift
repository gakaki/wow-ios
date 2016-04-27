//
//  WOWProvinceModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/27.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWProvinceModel: WOWBaseModel,Mappable{
    var name    : String?
    var citys   : [WOWCityModel]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["name"]
        citys   <- map["cityColection"]
    }
}



class WOWCityModel: WOWBaseModel ,Mappable{
    var name        :   String?
    var districts   :   [WOWDistrictModel]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        districts   <- map["districtCollection"]
    }
}

class WOWDistrictModel: WOWBaseModel ,Mappable{
    var name        :   String?
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
    }

}
