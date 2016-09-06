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
        return  " " + "\(self)" + "    "
    }
    /**
     返回数量带“X” 的字符串
     */
    func get_formted_X() -> String {
        if ( self.length <= 0){
            return ""
        }
        return  "X\(self)"
    }
    /**
     替换手机号中间四位为“****”
     */
    mutating func get_formted_xxPhone() ->  String{
        
        let subRange = Range(self.startIndex.advancedBy(3) ..< self.startIndex.advancedBy(7))
        
        self.replaceRange(subRange, with: "****")
        
        
        return self
    }
    
    
    /**
     *  获取路径
     */
    
    func documentDir() -> String {
        let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let mydocpath:String = mypaths.objectAtIndex(0) as! String
        let filepath = NSURL(fileURLWithPath: mydocpath).URLByAppendingPathComponent(self).path
        return filepath!
    }

}
