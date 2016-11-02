//
//  String+Add.swift
//  WowLib
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension String{
    /**
     单行的size
     
     - parameter font:
     
     - returns:
     */
    func size(_ font:UIFont) -> CGSize {
        let size: CGSize = self.size(attributes: [NSFontAttributeName:font])
        return size
    }
    
    /**
     计算高度的，根据宽度计算  带换行的
     
     - parameter width:
     - parameter font:
     
     - returns:
     */
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, lineSpace: CGFloat) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: self)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpace
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, self.characters.count))
        attributeString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, self.characters.count))
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = attributeString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
//        let boundingBox = attributeString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    
//    func toPinYin() -> String {
//        let s = self ?? ""
//        let string = NSMutableString(string:s) as CFMutableString
//        if CFStringTransform(string, nil, kCFStringTransformMandarinLatin,false) == true{
//            if CFStringTransform(string,nil, kCFStringTransformStripDiacritics, false) == true{
//                return string as String
//            }
//        }
//        return ""
//    }
    
    
    func validateMobile() -> Bool {
        // 手机号以 13 14 15 18 开头   八个 \d 数字字符
         let phoneRegex = "^((13[0-9])|(17[0-9])|(14[^4,\\D])|(15[^4,\\D])|(18[0-9]))\\d{8}$|^1(7[0-9])\\d{8}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
        return (phoneTest.evaluate(with: self));
    }
    
    
    func validateEmail()-> Bool {
        let phoneRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@" , phoneRegex)
        return (phoneTest.evaluate(with: self));
    }
    
    
    func priceFormat() -> String {
//        let price = Float(self)
//        guard let p = price else{
//            return "¥"
//        }
//        let number = NSNumber(float:p)
//        let numberFormat = NSNumberFormatter()
//        numberFormat.numberStyle = .DecimalStyle
//        let result = "¥" + (numberFormat.stringFromNumber(number) ?? "")
        
        
        let result = "¥ " + self
        return result
    }
    
}
