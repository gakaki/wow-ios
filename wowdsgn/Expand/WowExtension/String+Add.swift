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
        let s = self 
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
        
        //开始字符索引
        let startIndex = self.characters.index(self.startIndex, offsetBy: 3)
        //结束字符索引
        let endIndex = self.characters.index(self.startIndex, offsetBy: 7)
        let range = Range<String.Index>(startIndex..<endIndex)
        var s = String()
        for _ in 0..<7 - 3{
            s += "*"
        }
        return self.replacingCharacters(in: range, with: s)
    }
    /**
     将字符串替换*号
     
     - parameter str:        字符
     - parameter startindex: 开始字符索引
     - parameter endindex:   结束字符索引
     
     - returns: 替换后的字符串
     */
    
    static func stringByX(_ str:String,startindex:Int,endindex:Int) -> String{
        //开始字符索引
        let startIndex = str.characters.index(str.startIndex, offsetBy: startindex)
        //结束字符索引
        let endIndex = str.characters.index(str.startIndex, offsetBy: endindex)
        let range = Range<String.Index>(startIndex..<endIndex)
        var s = String()
        for _ in 0..<endindex - startindex{
            s += "*"
        }
        return str.replacingCharacters(in: range, with: s)
    }
    
    /**
     *  获取路径
     */
    
    func documentDir() -> String {
        let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let mydocpath:String = mypaths.object(at: 0) as! String
        let filepath = URL(fileURLWithPath: mydocpath).appendingPathComponent(self).path
        return filepath
    }

}
