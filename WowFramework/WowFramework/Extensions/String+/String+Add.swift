//
//  String+Add.swift
//  WowLib
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension String{
    func size(font:UIFont) -> CGSize {
        let size: CGSize = self.sizeWithAttributes([NSFontAttributeName:font])
        return size
    }
    
    func toPinYin() -> String? {
        var s = self ?? ""
        var string = NSMutableString(string:s) as CFMutableString
        if CFStringTransform(string, nil, kCFStringTransformMandarinLatin,false) == true{
            if CFStringTransform(string,nil, kCFStringTransformStripDiacritics, false) == true{
                return string as String
            }
        }
        return nil
    }
}