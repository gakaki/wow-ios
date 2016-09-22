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
    static func calGoodsDetailPrice(_ count:Int,perPrice:Float!) ->String{
        let count = NSDecimalNumber(value: count as Int)
        let price = NSDecimalNumber(value: perPrice as Float)
        let totalPrice = count.multiplying(by: price)
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        var result = numberFormat.string(from: totalPrice)
        result = result ?? ""
        return result!
    }
    
    /**
     计算商品价格，根据单价与数量计算
     
     - parameter prices: 商品的单价数组
     - parameter counts: 商品的数量
     
     - returns: 返回总价钱的字符串 （是带 ¥ 的）
     */
    static func calTotalPrice(_ prices:[Double],counts:[Int]) ->String{
        if prices.isEmpty {
            return "¥ 0.00"
        }
        var totalPrice = NSDecimalNumber(value: 0.00 as Double)
        for (index,value) in prices.enumerated() {
            let perPrice = NSDecimalNumber(value: value as Double)
            let countNumber = NSDecimalNumber(value: counts[index] as Int)
            let itemPrice = perPrice.multiplying(by: countNumber)
            totalPrice = totalPrice.adding(itemPrice)
        }
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        var result = numberFormat.string(from: totalPrice)
        result = "¥ " + (result ?? "0.00")
        
        return result!
    }
    static func totalPrice(_ prices:[Double],counts:[Int]) ->String{
        if prices.isEmpty {
            return "0.00"
        }
        var totalPrice = NSDecimalNumber(value: 0.00 as Double)
        for (index,value) in prices.enumerated() {
            let perPrice = NSDecimalNumber(value: value as Double)
            let countNumber = NSDecimalNumber(value: counts[index] as Int)
            let itemPrice = perPrice.multiplying(by: countNumber)
            totalPrice = totalPrice.adding(itemPrice)
        }
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        var result = numberFormat.string(from: totalPrice)
        result = result ?? "0.00"
        
        return result!
    }

}

/**
 转换Json字符串
 - parameter value:
 - parameter prettyPrinted:
 
 - returns:
 */
func JSONStringify(_ value: AnyObject,prettyPrinted:Bool = false) -> String{
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    if JSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
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
        let tel = URL(string: "tel:\(WOWCompanyTel)")
        web.loadRequest(URLRequest(URL: tel!))
        UIApplication.currentViewController()?.view.addSubview(web)
        
//        if let url = NSURL(string: "tel://\(WOWCompanyTel)") {
//            UIApplication.sharedApplication().openURL(url)
//        }
    }
    fileprivate static let WOWLastTabIndex      =  "lastTabIndex"

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


