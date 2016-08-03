//
//  WOWBuyCarMananger.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWBuyCarMananger {
    static let sharedBuyCar = WOWBuyCarMananger()
    private init() {}
    
     /// 选规格的时候弹出的框框用到的信息
//    var skuDataArr:[WOWProductSkuModel]?
    var productSpecModel    : WOWProductSpecModel?
    
    var isFavorite          : Bool?
    
    var skuName             : String?
    
    var buyCount            = 1
    
    var skuID :String       = ""
    
    var skuPrice:String     = ""
    
    var skuDefaultSelect    = 0
    
    //app启动这一次添加进购物车的商品列表
    var chooseProducts      = [String]()
    //登录成功的时候要将本地的和云端购物车的进行累加
    static func updateBadge(isLoginSuccess:Bool = false){
//        let vc = UIApplication.appTabBarController.viewControllers![2]
//        if WOWUserManager.loginStatus {
//            let carCount = WOWUserManager.userCarCount
//            if  carCount == 0 {
//                vc.tabBarItem.badgeValue = nil
//            }else{
//                if isLoginSuccess {
//                    let products = WOWRealm.objects(WOWBuyCarModel)
//                    var count = 0
//                    for p in products {
//                        count += p.skuProductCount
//                    }
//                    vc.tabBarItem.badgeValue = "\(carCount + count)" ?? ""
//                }else{
//                    vc.tabBarItem.badgeValue = "\(carCount)" ?? ""
//                }
//            }
//        }else{
//            let products = WOWRealm.objects(WOWBuyCarModel)
//            var count = 0
//            for p in products {
//                count += p.skuProductCount
//            }
//            if count == 0 {
//                vc.tabBarItem.badgeValue = nil
//            }else{
//                vc.tabBarItem.badgeValue = "\(count)" ?? ""
//            }
//        }
    }
    
//    static func calCarCount() ->String{
//        var count = 0
//        if WOWUserManager.loginStatus {
//            count = WOWUserManager.userCarCount
//        }else{
//            let products = WOWRealm.objects(WOWCarProductModel)
//            for p in products {
//                count += p.skuProductCount
//            }
//        }
//        if count == 0 {
//            return ""
//        }else{
//            return "\(count)"
//        }
//    }
}





