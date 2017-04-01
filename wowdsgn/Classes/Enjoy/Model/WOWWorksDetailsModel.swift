//
//  WOWWorksDetailsModel.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWWorksDetailsModel: WOWBaseModel,Mappable  {
    var id                      :  Int?
    var avatar                  :  String?
    var categoryId              :  Int?
    var categoryName            :  String?
    var des                     :  String?
    var endUserId               :  Int?
    var instagramCounts         :  Int?
    var likeCounts              :  Int?
    var collectCounts           :  Int?
    var nickName                :  String?
    var pic                     :  String?
    
    var picHeight               : CGFloat = MGScreenWidth
    
    var totalCollectCounts      :  Int?
    var totalLikeCounts         :  Int?
    var like                    :  Bool?
    var collect                 :  Bool?
    var measurement             :  Int?
    var myInstagram             :  Bool?
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        id                                          <- map["id"]
        avatar                                      <- map["avatar"]
        categoryId                                  <- map["categoryId"]
        categoryName                                <- map["categoryName"]
        des                                         <- map["description"]
        endUserId                                   <- map["endUserId"]
        instagramCounts                             <- map["instagramCounts"]
        likeCounts                                  <- map["likeCounts"]
        collectCounts                               <- map["collectCounts"]
        nickName                                    <- map["nickName"]
        pic                                         <- map["pic"]
        totalCollectCounts                          <- map["totalCollectCounts"]
        totalLikeCounts                             <- map["totalLikeCounts"]
        like                                        <- map["like"]
        collect                                     <- map["collect"]
        measurement                                 <- map["measurement"]
        myInstagram                                 <- map["myInstagram"]
        if let pic = pic ,let measurement = measurement {
            if pic.contains("_2dimension_") {
                
                picHeight =  WOWArrayAddStr.get_img_sizeNew(str: pic , width: MGScreenWidth, defaule_size: .OneToOne)
                
            }else{
                
                switch  measurement {
                case 1:
                    picHeight = MGScreenWidth * 1
                    break
                case 2:
                    picHeight = MGScreenWidth * 0.67
                    break
                case 3:
                    picHeight = MGScreenWidth * 0.75
                    break
                case 4:
                    picHeight = MGScreenWidth * 0.56
                    break
                default:
                    break
                    
                }

            }
        }
        
    }

}
