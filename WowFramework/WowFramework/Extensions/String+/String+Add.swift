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
    func size(font:UIFont) -> CGSize {
        let size: CGSize = self.sizeWithAttributes([NSFontAttributeName:font])
        return size
    }
    
    /**
     计算高度的，根据宽度计算  带换行的
     
     - parameter width:
     - parameter font:
     
     - returns:
     */
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
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
}