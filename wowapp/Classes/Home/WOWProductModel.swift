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
    var sellPrice             : Double?
    var original_price        : Double?
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
    var productParameter      : WOWParameter?
    var productImg            : String?
    
    
    
    override init() {
        super.init()
    }
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {

        
        /*************************新版Map***********************/
        productId               <- map["productId"]
        primaryImgs             <- map["primaryImgs"]
        productName             <- map["productName"]
        sellPrice               <- map["sellPrice"]
        original_price          <- map["originalPrice"]
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
        productParameter        <- map["productParameter"]
        productImg              <- map["productImg"]
    
        
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
