//
//  String+Add.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
extension String{
    func toPinYin() -> String {
        let s = self ?? ""
        let string = NSMutableString(string:s) as CFMutableString
        if CFStringTransform(string, nil, kCFStringTransformMandarinLatin,false) == true{
            if CFStringTransform(string,nil, kCFStringTransformStripDiacritics, false) == true{
                return string as String
            }
        }
        return "#"
    }
    /**
     返回价格带“¥” 的字符串
     */
    func get_formted_price() -> String {
        if ( self.length <= 0){
            return ""
        }
        return "¥\(self)"
    }
    /**
     返回 前后都加空格 的字符串
     */
    func get_formted_Space() -> String {
        if ( self.length <= 0){
            return ""
        }
        return  "  " + "\(self)" + "   "
    }

}
