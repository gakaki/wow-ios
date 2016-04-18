//
//  WOWTool.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

struct WOWCalPrice {
    static func calGoodsDetailPrice(count:Int,perPrice:Float!) ->String{
        let count = NSDecimalNumber(long: count)
        let price = NSDecimalNumber(float: perPrice)
        let totalPrice = count.decimalNumberByMultiplyingBy(price)
        
        let numberFormat = NSNumberFormatter()
        numberFormat.numberStyle = .DecimalStyle
        var result = numberFormat.stringFromNumber(totalPrice)
        result = result ?? ""
        return result!
    }
}


struct WOWTool {
    static var appTab:UITabBarController {
        get{
            let del = UIApplication.sharedApplication().delegate as? AppDelegate
            let tab = del?.sideController.mainController as! UITabBarController
            return tab
        }
    }
}


