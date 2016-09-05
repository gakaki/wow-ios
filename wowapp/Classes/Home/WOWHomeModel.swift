//
//  WOWHomeModel.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/2.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWHomeModel: WOWBaseModel,Mappable {
    var pageId               :   Int?
    var region          :   Int?
    var moduleDataList          :  [WOWCarouselBanners]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        pageId                 <- map["pageId"]
        region            <- map["region"]
        moduleDataList            <- map["moduleDataList"]
        
    }

}
final class WOWHomeModule: WOWBaseModel,Mappable{
    var moduleType    :   Int?
    var moduleContent         :  [WOWHomeBannerr]?
    var moduleContentList         :  [WOWModelVoTopic]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        moduleType    <- map["moduleType"]
        
        switch moduleType! {
        case 101:
            moduleContent         <- map["moduleContent"]
            print("顶部轮播")
        case 201:
            moduleContent         <- map["moduleContent"]
            print("单个图片")
        case 601:
            print("产品列表CollectionView")
            moduleContentList         <- map["moduleContent"]
        default:
            break
        }
//        moduleContent         <- map["moduleContent"]

    }
}
