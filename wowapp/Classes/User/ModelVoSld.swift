//
//  ModelSld.swift
//  sld
//
//  Created by g on 16/7/26.
//  Copyright © 2016年 g. All rights reserved.
//
import JSONCodable

struct VoSld {
    var id:String               = ""
    var name:String             = ""
    var parent_id:String        = ""
    var level_type:String       = ""
}

struct VoSldData {
    
    var slds: [VoSld]           = []
    
    var provinces:[VoSld]       = [] //省
    var cities:[VoSld]          = [] //市
    var districts:[VoSld]       = [] //区
    
    
}

extension VoSldData: JSONDecodable {
    
    func getProvinceFirst() -> VoSld {
        return provinces[0] //北京那个咯
    }
    
    func getSubCities( province:VoSld ) -> [VoSld]{
        let sub_cities = cities.filter { (c) -> Bool in
            c.parent_id == province.id
        }
        return sub_cities
    }
    
    func getSubDistricts(city:VoSld)-> [VoSld]{
        let sub_districts = districts.filter { (d) -> Bool in
            d.parent_id == city.id
        }
        return sub_districts
    }
    
    mutating func filter_data(){
        for vo in slds {
            if ( vo.level_type == "1" ) {
                provinces.append(vo)
            }else if ( vo.level_type == "2" ) {
                cities.append(vo)
            }else if ( vo.level_type == "3" ) {
                districts.append(vo)
            }
        }
    }
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        slds = try decoder.decode("RECORDS")

    //        province    = slds.filter{ (sld) in sld.level_type == "1" }
    //        cities      = slds.filter{ (sld) in sld.level_type == "2" }
    //        districts   = slds.filter{ (sld) in sld.level_type == "3" }
        filter_data()
//        print(slds)
    }
}

extension VoSld: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        id              = try decoder.decode("id")
        name            = try decoder.decode("name")
        parent_id       = try decoder.decode("parent_id")
        level_type      = try decoder.decode("level_type")
    }
}


