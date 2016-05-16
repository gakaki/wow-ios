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
    var producModel:WOWProductModel?
    
    var skuName:String?
    
    var buyCount            = 1
    
    var skuID :String       = ""
    
    var skuPrice:String     = ""
    
    var skuDefaultSelect    = 0
    
    //app启动这一次添加进购物车的商品列表
    var chooseProducts      = [String]()
    
    static func updateBadge(count:Int = 0){
        let vc = WOWTool.appTabBarController.viewControllers![2]
        if WOWUserManager.loginStatus {
            if  count == 0 {
                vc.tabBarItem.badgeValue = nil
            }else{
                vc.tabBarItem.badgeValue = "\(count)" ?? ""
            }
        }else{
            let products = WOWRealm.objects(WOWBuyCarModel)
            if products.count == 0 {
                vc.tabBarItem.badgeValue = nil
            }else{
                vc.tabBarItem.badgeValue = "\(products.count)" ?? ""
            }
        }
    }
    
    static func calCarCount() ->String{
        var count = 0
        if WOWUserManager.loginStatus {
            count = WOWUserManager.userCarCount
        }else{
            let products = WOWRealm.objects(WOWBuyCarModel)
            count = products.count
        }
        if count == 0 {
            return ""
        }else{
            return "\(count)"
        }
    }
}





