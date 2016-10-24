//
//  WOWAttributeModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWAttributeModel: WOWBaseModel,Mappable{
    
    var code        :String?
    var title       :String?
    var value       :String?
    var attriImage  :String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code        <- map["key"]
        value       <- map["value"]
        title       <- map["label"]
        attriImage  <- map["pic_app"]
    }
}

class WOWParameter: WOWBaseModel,Mappable{
    
    var parameterShowName        :String?
    var parameterValue           :String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        parameterShowName            <- map["parameterShowName"]
        parameterValue               <- map["parameterValue"]
    }
}


class WOWProductPicTextModel:WOWBaseModel,Mappable {
    var image  :String?
    var text    :String = ""
    var imageAspect:CGFloat = 0
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["url"]
        text  <- map["desc"]
        if imageAspect == 0 {
            calImageHeight()
        }
    }
    
    func calImageHeight(){
        //定义NSURL对象
        let url = NSURL(string: image ?? "")
        DispatchQueue.global(qos: .background).async {
            if let data = NSData(contentsOf: url as! URL), let image = UIImage(data: data as Data) {
                //计算原始图片的宽高比
                self.imageAspect = image.size.width / image.size.height
                //            //设置imageView宽高比约束
                //            //加载图片
                //
                
            }
        }
        
    }
}


//class WOWProductSkuModel: WOWBaseModel,Mappable {
//    var skuID       : String?
//    var skuTitle    : String?
//    var skuPrice    : String?
//
//    required init?( map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        skuID       <- map["sku"]
//        skuTitle    <- map["title"]
//        skuPrice    <- map["price"]
//    }
//}
