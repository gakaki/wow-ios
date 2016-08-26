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
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        var result = numberFormat.stringFromNumber(totalPrice)
        result = result ?? ""
        return result!
    }
    
    /**
     计算商品价格，根据单价与数量计算
     
     - parameter prices: 商品的单价数组
     - parameter counts: 商品的数量
     
     - returns: 返回总价钱的字符串 （是带 ¥ 的）
     */
    static func calTotalPrice(prices:[Double],counts:[Int]) ->String{
        if prices.isEmpty {
            return "¥ 0.00"
        }
        var totalPrice = NSDecimalNumber(double:0.00)
        for (index,value) in prices.enumerate() {
            let perPrice = NSDecimalNumber(double: value)
            let countNumber = NSDecimalNumber(integer:counts[index])
            let itemPrice = perPrice.decimalNumberByMultiplyingBy(countNumber)
            totalPrice = totalPrice.decimalNumberByAdding(itemPrice)
        }
        let numberFormat = NSNumberFormatter()
        numberFormat.numberStyle = .DecimalStyle
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        var result = numberFormat.stringFromNumber(totalPrice)
        result = "¥ " + (result ?? "0.00")
        
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
            DLog("error")
            
        }
    }
    return ""
    
}



struct WOWTool {
    static func callPhone(){
        let web = UIWebView()
        let tel = NSURL(string: "tel:\(WOWCompanyTel)")
        web.loadRequest(NSURLRequest(URL: tel!))
        UIApplication.currentViewController()?.view.addSubview(web)
        
//        if let url = NSURL(string: "tel://\(WOWCompanyTel)") {
//            UIApplication.sharedApplication().openURL(url)
//        }
    }
    private static let WOWLastTabIndex      =  "lastTabIndex"

    static var lastTabIndex:Int {
        get{
            return (MGDefault.objectForKey(WOWLastTabIndex) as? Int) ?? 0
        }
        set{
            MGDefault.setObject(newValue, forKey:WOWLastTabIndex)
            MGDefault.synchronize()
        }
    }
    
}


