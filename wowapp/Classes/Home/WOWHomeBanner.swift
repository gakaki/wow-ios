//
//  WOWHomeBanner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/25.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWHomeBanner: WOWBaseModel,Mappable {
    var bannerList               :   [WOWCarouselBanners]?
    var carouselBanners          :   [WOWCarouselBanners]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        bannerList                 <- map["bannerList"]
        carouselBanners            <- map["carouselBanners"]
       
    }

}
final class WOWCarouselBanners: WOWBaseModel,Mappable{
    var bannerLinkTargetId    :   Int?
    var bannerLinkUrl         :   String?
    var bannerImgSrc          :   String?
    var bannerLinkType        :   Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        bannerLinkTargetId    <- map["bannerLinkTargetId"]
        bannerLinkUrl         <- map["bannerLinkUrl"]
        bannerImgSrc          <- map["bannerImgSrc"]
        bannerLinkType        <- map["bannerLinkType"]
    }
}
