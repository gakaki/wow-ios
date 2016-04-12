//
//  UIFont+Add.swift
//  SwiftProject
//
//  Created by 王云鹏 on 16/3/3.
//  Copyright © 2016年 王涛. All rights reserved.
//

import Foundation

public extension UIFont{
    static var scale:CGFloat{
        get {
            return 1.2
        }
    }
    
    /**
     判断设备字体进行放缩
    
     - parameter fontSize:
     */
    static func systemScaleFontSize(fontSize:CGFloat) ->UIFont{
        switch UIDevice.deviceType{
            case .DT_iPhone6_Plus:
                return UIFont.systemFontOfSize(fontSize * CGFloat(scale))
            default:
                return UIFont.systemFontOfSize(fontSize)
        }
    }
    
    static func mediumScaleFontSize(fontSize:CGFloat) ->UIFont{
        switch UIDevice.deviceType{
        case .DT_iPhone6_Plus:
            return UIFont.init(name:"HelveticaNeue-Medium", size:fontSize * CGFloat(scale))!
        default:
            return UIFont.init(name:"HelveticaNeue-Medium", size:fontSize)!
        }
    }
    
}
