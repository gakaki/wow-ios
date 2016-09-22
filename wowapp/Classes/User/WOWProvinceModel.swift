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
    
    func mapping(_ map: Map) {
        name    <- map["name"]
        citys   <- map["cityColection"]
    }
}



class WOWCityModel: WOWBaseModel ,Mappable{
    var name        :   String?
    var districts   :   [WOWDistrictModel]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        name        <- map["name"]
        districts   <- map["districtCollection"]
    }
}

class WOWDistrictModel: WOWBaseModel ,Mappable{
    var name        :   String?
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        name        <- map["name"]
    }

}


class WOWSimpleSSQRepo{
    
    var citys:[WOWSimpleSSQModel]   = [];
    var provines:[WOWSimpleSSQModel]   = [];
    var districts:[WOWSimpleSSQModel]   = [];
    
    required init?() {
        
        //        let array = dict.objectForKey("RECORDS") as? NSArray
        //        for dict in array! {
        //            if (String(dict["level_type"]) == "1") {
        //                provinces?.arrayByAddingObject(dict)
        //            }
        //            if (String(dict["level_type"]) == "1") {
        //                cities?.arrayByAddingObject(dict)
        //            }
        //            if (String(dict["level_type"]) == "1") {
        //                districts?.arrayByAddingObject(dict)
        //            }
        //        }
    }
}

class WOWSimpleSSQModel: WOWBaseModel ,Mappable{
    
    var id                  :   String?     //"id":"110000",
    var name                :   String?     //"name":"北京",
    var parent_id           :   String?     //"parent_id":"0",
    var level_type          :   String?     // "level_type":"1"
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        parent_id           <- map["parent_id"]
        level_type          <- map["level_type"]
    }
    
}

