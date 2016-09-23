//
//  WOWHomeBanner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/25.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper
//暂时不用
class WOWHomeBanner: WOWBaseModel,Mappable {
    var bannerList               :   [WOWCarouselBanners]?
    var carouselBanners          :   [WOWCarouselBanners]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        bannerList                 <- map["bannerList"]
        carouselBanners            <- map["carouselBanners"]
       
    }

}

//暂时不用
class WOWHomeBannerr: WOWBaseModel,Mappable {
    //moduleType = 101
    var banners               :   [WOWCarouselBanners]?
    //moduleType = 201
    var bannerImgSrc          :     String?
    var bannerLinkType        :     Int?
    var bannerLinkTargetId    :     Int?
    var bannerLinkUrl         :     String?

    
   
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        banners                 <- map["banners"]

        bannerImgSrc            <- map["bannerImgSrc"]
        bannerLinkType          <- map["bannerLinkType"]
        bannerLinkTargetId      <- map["bannerLinkTargetId"]
        bannerLinkUrl           <- map["bannerLinkUrl"]

        
    }
    
}


final class WOWCarouselBanners: WOWBaseModel,Mappable{
    var banners               :   [WOWCarouselBanners]?
    
    var bannerLinkTargetId    :   Int?
    var bannerLinkUrl         :   String?
    var bannerImgSrc          :   String?
    var bannerLinkType        :   Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        banners                 <- map["banners"]
        
        bannerLinkTargetId    <- map["bannerLinkTargetId"]
        bannerLinkUrl         <- map["bannerLinkUrl"]
        bannerImgSrc          <- map["bannerImgSrc"]
        bannerLinkType        <- map["bannerLinkType"]
    }
}
