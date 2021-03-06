//
//  WOWProductModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWProductModel: WOWBaseModel,Mappable{
   
    
    var productId             : Int?
    var primaryImgs           : Array<String>?
    var productName           : String?
    var productTitle          : String?
    var sellPrice             : Double?
    var originalprice         : Double?
    var sellingPoint          : String?
    var brandCname            : String?
    var brandId               : Int?
    var brandLogoImg          : String?
    var designerId            : Int?
    var designerName          : String?
    var designerPhoto         : String?
    var firstNonPrimaryImgUrl : String?
    var firstNonPrimaryImgDesc: String?
    var detailDescription     : String?
    var productParameter      : [WOWParameter]?
    var productImg            : String?
    var secondaryImgs         : [WOWProductPicTextModel]?
    var pageModuleType        :   Int?
    
    var productStatus         : Int?
    var sings                 : [WOWProductSings]?
    dynamic var timeoutSeconds : Int = 0
    var favorite              : Bool?
    var discount              : String?
    var productStock          : Int?
    //商品限购信息

    var limitTag                    : String?
    
    //商品详情中用到
    var length                      : NSNumber?
    var width                       : NSNumber?
    var height                      : NSNumber?
    var netWeight                   : NSNumber?
    var attributes                  : [WOWSerialAttributeModel]?
    var availableStock              : Int?
    var hasStock                    : Bool?
    var productQty                  : Int?
    var isOversea                   : Bool? //是否海购,是-true,否-false
    var logisticsMode               : Int?  //1-海外直邮，2-保税区直邮
    var originCountry               : String?   //国家名字
    var originCountryId             : Int?      //国家id
    
    override init() {
        super.init()
    }
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {

        
        /*************************新版Map***********************/
        productId               <- map["productId"]
        primaryImgs             <- map["primaryImgs"]

        productName             <- map["productTitle"]
        productTitle            <- map["productTitle"]

        sellPrice               <- map["sellPrice"]
        originalprice           <- map["originalPrice"]
        sellingPoint            <- map["sellingPoint"]
        brandCname              <- map["brandCname"]
        brandId                 <- map["brandId"]
        brandLogoImg            <- map["brandLogoImg"]
        designerName            <- map["designerName"]
        designerId              <- map["designerId"]
        designerPhoto           <- map["designerPhoto"]
        firstNonPrimaryImgUrl   <- map["firstNonPrimaryImgUrl"]
        firstNonPrimaryImgDesc  <- map["firstNonPrimaryImgDesc"]
        detailDescription       <- map["detailDescription"]
        productParameter        <- map["parameters"]
        productImg              <- map["productImg"]
        secondaryImgs           <- map["secondaryImgs"]
        pageModuleType          <- map["pageModuleType"]

        productStatus           <- map["productStatus"]
        sings                   <- map["signs"]
        timeoutSeconds          <- map["timeoutSeconds"]
        
        productStock            <- map["productStock"]
        
        favorite                <- map["favorite"]
     
        length                      <- map["length"]
        width                       <- map["width"]
        height                      <- map["height"]
        netWeight                   <- map["netWeight"]
        attributes                  <- map["attributes"]
        availableStock              <- map["availableStock"]
        hasStock                    <- map["hasStock"]
        
        isOversea                   <- map["isOversea"]
        logisticsMode               <- map["logisticsMode"]
        originCountry               <- map["originCountry"]
        originCountryId             <- map["originCountryId"]

    }
    
    /// 商品列表瀑布流需要用的高度
    var cellHeight:CGFloat = 0
    func calCellHeight(){
//        let s = self.productShortDes ?? ""
//        var height = s.heightWithConstrainedWidth((MGScreenWidth - CGFloat(3)) / CGFloat(2) - 30, font: UIFont.systemScaleFontSize(13))
//        height = height > 18 ? 30 : 18
//        self.cellHeight = 20 + 5 + 14 + height + 6 + WOWGoodsSmallCell.itemWidth
    }
    
}
class WOWProductSings: WOWBaseModel,Mappable {
    
    var id                  : Int?
    var desc                : String?
    var extra               : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <- map["id"]
        desc            <- map["desc"]
        extra           <- map["extra"]
        
    }
    
}
