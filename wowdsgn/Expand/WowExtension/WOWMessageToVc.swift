//
//  WOWMessageToVc.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/22.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

public class WOWMessageToVc: NSObject {

    public class func goVc(type: String? ,id: String?) {
        if let type = type {
            switch type {
            case "101"://首页
                
                let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                UIApplication.appTabBarController.selectedIndex = 0
                WOWTool.lastTabIndex = 0
            case "102"://购物
                
                let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                UIApplication.appTabBarController.selectedIndex = 1
                WOWTool.lastTabIndex = 1
                
            case "103"://精选
                let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                UIApplication.appTabBarController.selectedIndex = 2
                WOWTool.lastTabIndex = 2
                
            case "104"://喜欢
                guard WOWUserManager.loginStatus else{
                    UIApplication.currentViewController()?.toLoginVC(true)
                    return
                }
                let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                UIApplication.appTabBarController.selectedIndex = 3
                WOWTool.lastTabIndex = 3
            case "105"://我
                let _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: false)
                UIApplication.appTabBarController.selectedIndex = 4
                WOWTool.lastTabIndex = 4
                
            case "201"://商品详情
                if let id = id {
                    
                    VCRedirect.toVCProduct(id.toInt())
                    
                }
                
            case "202"://内容专题详情
                if let id = id {
                    
                    VCRedirect.toToPidDetail(topicId: id.toInt() ?? 0)
                    
                }
                
            case "203"://商品列表专题详情
                if let id = id {
                    
                    VCRedirect.toTopicList(topicId: id.toInt() ?? 0)
                    
                }
            case "204"://H5
                
                VCRedirect.toVCH5(id)
                
            case "205"://品牌详情
                if let id = id {
                    
                    VCRedirect.toBrand(brand_id: id.toInt())
                    
                }
            case "206"://设计师详情
                if let id = id {
                    
                    VCRedirect.toDesigner(designerId: id.toInt())
                    
                }
            case "207"://分类详情
                if let id = id {
                    
                    VCRedirect.toVCCategory(id.toInt())
                    
                }
            case "208"://优惠券列表
                
                VCRedirect.toCouponVC()
                
            case "209"://订单列表
                if let id = id {
                    guard WOWUserManager.loginStatus else{
                        UIApplication.currentViewController()?.toLoginVC(true)
                        return
                    }
                    let vc = WOWOrderListViewController()
                    vc.selectCurrentIndex = id.toInt() ?? 0
                    UIApplication.currentViewController()?.pushVC(vc)
                }
            case "210"://订单详情
                if let id = id {
                    
                    VCRedirect.toOrderDetail(orderCode: id)
                    
                }
            case "211"://AppStore
                
                GoToItunesApp.show()
            case "212": //产品组
                if let id = id {
                    VCRedirect.goToProductGroup(id.toInt() ?? 0)
                }
                
            default:
                break
            }
        }

    }
}
