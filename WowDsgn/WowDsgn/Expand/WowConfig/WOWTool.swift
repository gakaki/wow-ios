//
//  WOWTool.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

struct WOWCalPrice {
    /**
     计算价钱
     
     - parameter count:
     - parameter perPrice:
     
     - returns:
     */
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
    
    static func calTotalPrice(prices:[String],counts:[Int]) ->String{
        if prices.isEmpty {
            return "0"
        }
        var totalPrice = NSDecimalNumber(float:0)
        for (index,value) in prices.enumerate() {
            let perPrice = NSDecimalNumber(string:value)
            let countNumber = NSDecimalNumber(integer:counts[index])
            let itemPrice = perPrice.decimalNumberByMultiplyingBy(countNumber)
            totalPrice = totalPrice.decimalNumberByAdding(itemPrice)
        }
        let numberFormat = NSNumberFormatter()
        numberFormat.numberStyle = .DecimalStyle
        var result = numberFormat.stringFromNumber(totalPrice)
        result = result ?? "0"
        return result!
    }
}

/**
 转换Json字符串
 - parameter value:
 - parameter prettyPrinted:
 
 - returns:
 */
func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    if NSJSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }catch {
            print("error")
            
        }
    }
    return ""
    
}



struct WOWTool {
    static var appTabBarController:UITabBarController {
        get{
//            let del = UIApplication.sharedApplication().delegate as? AppDelegate
//            let tab = del?.window?.rootViewController as! UITabBarController
//            let tab = del?.sideController.mainController as! UITabBarController
            return AppDelegate.rootVC as! UITabBarController
        }
    }
    
    
    static func callPhone(){
        if let url = NSURL(string: "tel://\(WOWCompanyTel)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    
}


