//
//  UIFont+Add.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

public enum FontWeight {
    case Normal
    case Regular
    case Bold
    case Black
    case Heavy
    case Semibold
    case Thin
    case Light
    case UltraLight
}

extension  UIFont{
   class func priceFont(size:CGFloat = 12) -> UIFont{
        return UIFont(name: "DIN Alternate", size:size) ?? UIFont.systemFontOfSize(size)
    }
}
// MARK:systemFontOfSize
extension UIFont {
    
    @available(iOS 7, *)
    public class func systemFontOfSize(size: Double, weight: FontWeight) -> UIFont {
        if #available(iOS 8.2, *) {
            let fontWeightFloat: CGFloat
            switch weight {
            case .UltraLight:
                fontWeightFloat = UIFontWeightUltraLight
            case .Light:
                fontWeightFloat = UIFontWeightLight
            case .Thin:
                fontWeightFloat = UIFontWeightThin
            case .Normal:
                fontWeightFloat = UIFontWeightRegular
            case .Regular:
                fontWeightFloat = UIFontWeightMedium
            case .Semibold:
                fontWeightFloat = UIFontWeightSemibold
            case .Bold:
                fontWeightFloat = UIFontWeightBold
            case .Heavy:
                fontWeightFloat = UIFontWeightHeavy
            case .Black:
                fontWeightFloat = UIFontWeightBlack
            }
            
            return UIFont.systemFontOfSize(CGFloat(size), weight: fontWeightFloat)
        } else {
            let systemFontName: String
            switch weight {
            case .UltraLight:
                systemFontName = "HelveticaNeue-UltraLight"
            case .Light:
                systemFontName = "HelveticaNeue-Light"
            case .Thin:
                systemFontName = "HelveticaNeue-Thin"
            case .Normal:
                systemFontName = "HelveticaNeue"
            case .Regular:
                systemFontName = "HelveticaNeue-Medium"
            case .Semibold:
                systemFontName = "HelveticaNeue-Medium"
            case .Bold:
                systemFontName = "HelveticaNeue-Bold"
            case .Heavy:
                systemFontName = "HelveticaNeue-Bold"
            case .Black:
                systemFontName = "HelveticaNeue-Bold"
            }
            
            return UIFont(name: systemFontName, size: CGFloat(size))!
        }
    }
    
}
