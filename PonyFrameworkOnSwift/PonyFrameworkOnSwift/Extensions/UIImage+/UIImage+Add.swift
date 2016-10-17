//
//  UIImage+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
public extension UIImage {
    /**
     根据颜色和尺寸生成一张图片
     
     - parameter color: 颜色
     - parameter size:  尺寸
     
     - returns: 图片
     */
    class func imageWithColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: MGScreenWidth, height: MGScreenHeight), true, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0,width: MGScreenWidth,height: MGScreenHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func imageWithColor(_ color: UIColor,size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), true, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0,width: size.width,height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
