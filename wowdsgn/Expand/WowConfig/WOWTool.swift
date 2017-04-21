
//
//  WOWTool.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
struct WOWDelay {
    // delay -- 多少秒后结束 回掉
    func start(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
}
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
/**
 *  自增自减 1
 */
struct Calculate {
    
    static func increase(input:Int) -> Int{
        return input + 1
    }
    
    static func reduce(input:Int) -> Int{
        return input - 1
    }
    //定义一个返回函数类型的函数
    static func calculateType(type:Bool) -> (Int) -> Int{
        return type ? increase : reduce
    }
    
}
public enum Defaule_Size : Float{
    
    case ThreeToTwo = 0.67
    case ThreeToOne = 0.33
    case OneToOne   = 1
}
/**
 转换数组url
 - parameter array:     需要转化的数组
 
 - returns:
 */
struct WOWArrayAddStr {
    static func strAddJPG(array : [String]) -> Array<String>{
        var newArray = [String]()
        for a in 0..<array.count {
            var str = array[a]
            str = String(format: "%@?imageMogr2/format/jpg", str)
            newArray.append(str)
            
        }
        return newArray
    }
    // 后台返回的图片后面有图片size的参数 此方法拿到。直接返回算出的高度
    static func get_img_sizeNew(str:String,width:CGFloat,defaule_size:Defaule_Size) -> CGFloat {
        
        let array = str.components(separatedBy: "_2dimension_")
    
        var rate        = defaule_size.rawValue
        if array.count > 1 {
            let c = array[1].components(separatedBy: ".")
            if c.count >= 1 {
                let d = c[0].components(separatedBy: "x")
                if d.count > 1 {
                    
                    if let height = d[1].toFloat(),let width = d[0].toFloat() {
                        rate = height / width
                    }
                    
                }
            }
            
        }
        return round(CGFloat(rate) * width)
    }

    
    // 后台返回的图片后面有图片size的参数 此方法拿到。 默认 1比1
   static func get_img_size(str:String) -> Float {
    
        let array = str.components(separatedBy: "_2dimension_")
        var pointArr:[String] = ["100","100"]
    
        if array.count > 1 {
            
            pointArr = array[1].components(separatedBy: ".")[0].components(separatedBy: "x")
            
        }
        return pointArr[1].toFloat()! / pointArr[0].toFloat()!
    }
    // 后台返回的图片后面有图片size的参数 此方法拿到。 默认 三比二
    static func get_img_size_withThreeTwo(str:String) -> Float {
        
        let array = str.components(separatedBy: "_2dimension_")
        var pointArr:[String] = ["100","67"]
        
        if array.count > 1 {
            
            pointArr = array[1].components(separatedBy: ".")[0].components(separatedBy: "x")
            
        }
        return pointArr[1].toFloat()! / pointArr[0].toFloat()!
    }
    
    // 后台返回的图片后面有图片size的参数 此方法拿到。 默认 三比二
    static func get_imageAspect(str:String) -> Float {
        
        let array = str.components(separatedBy: "_2dimension_")
        var pointArr:[String]
        
        if array.count > 1 {
            
            pointArr = array[1].components(separatedBy: ".")[0].components(separatedBy: "x")
            return pointArr[0].toFloat()! / pointArr[1].toFloat()!

        }
        return 0
    }

}

struct WOWTool {
    static func callPhone(){
        let web = UIWebView()
        let tel = URL(string: "tel:\(WOWCompanyTel)")
        web.loadRequest(URLRequest(url: tel!))
        UIApplication.currentViewController()?.view.addSubview(web)
        
//        if let url = NSURL(string: "tel://\(WOWCompanyTel)") {
//            UIApplication.sharedApplication().openURL(url)
//        }
    }
    fileprivate static let WOWLastTabIndex      =  "lastTabIndex"

    static var lastTabIndex:Int {
        get{
            return (MGDefault.object(forKey: WOWLastTabIndex) as? Int) ?? 0
        }
        set{
            MGDefault.set(newValue, forKey:WOWLastTabIndex)
            MGDefault.synchronize()
        }
    }
    static func cheakPhone(phontStr:String?)-> Bool {
        guard let phone = phontStr , !phone.isEmpty else{
            
            WOWHud.showMsg("请输入手机号")
            
            return false
        }
        guard phone.validateMobile() || phone.validateEmail() else{
            WOWHud.showMsg("请输入正确的手机号")
            return false
        }
        return true
    }
    // 拼接图片url 后台定义的 以“,”间隔~~  类似于“a,b,c”
    static func jointImgStr(imgArray:[String],spaceStr:String) -> String {
        var imgStr = ""
        for str in imgArray.enumerated(){
            if str.offset == 0 {
                imgStr = str.element
            }else {
                imgStr = imgStr + spaceStr + str.element
            }
            
            
        }
        return imgStr
        
    }

    
}
// 前往AppStore
struct GoToItunesApp {
    static func show (){
        
        let url = URL(string:urlItunes)
        UIApplication.shared.openURL(url!)
        
    }
}

struct productSpec {
    /**
     *  格式化产品尺寸
     */
   static func productSize(productInfo: WOWProductModel) -> String {
        let format = String(format:"L%g×W%g×H%gcm",productInfo.length?.floatValue ?? 0, productInfo.width?.floatValue ?? 0, productInfo.height?.floatValue ?? 0)
        return format
    }
    /**
     *  格式化产品尺寸重量
     */
    static func productWeight(productInfo: WOWProductModel) -> String {
        let format = String(format:"%gkg",productInfo.netWeight?.floatValue ?? 0)
        return format
    }
}
