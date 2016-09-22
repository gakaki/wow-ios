//
//  UIFont+Add.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

public enum FontWeight {
    case normal
    case regular
    case bold
    case black
    case heavy
    case semibold
    case thin
    case light
    case ultraLight
}

extension  UIFont{
   class func priceFont(_ size:CGFloat = 12) -> UIFont{
        return UIFont(name: "DIN Alternate", size:size) ?? UIFont.systemFont(ofSize: size)
    }
}
// MARK:systemFontOfSize
extension UIFont {
    
    @available(iOS 7, *)
    public class func systemFontOfSize(_ size: Double, weight: FontWeight) -> UIFont {
        if #available(iOS 8.2, *) {
            let fontWeightFloat: CGFloat
            switch weight {
            case .ultraLight:
                fontWeightFloat = UIFontWeightUltraLight
            case .light:
                fontWeightFloat = UIFontWeightLight
            case .thin:
                fontWeightFloat = UIFontWeightThin
            case .normal:
                fontWeightFloat = UIFontWeightRegular
            case .regular:
                fontWeightFloat = UIFontWeightMedium
            case .semibold:
                fontWeightFloat = UIFontWeightSemibold
            case .bold:
                fontWeightFloat = UIFontWeightBold
            case .heavy:
                fontWeightFloat = UIFontWeightHeavy
            case .black:
                fontWeightFloat = UIFontWeightBlack
            }
            
            return UIFont.systemFont(ofSize: CGFloat(size), weight: fontWeightFloat)
        } else {
            let systemFontName: String
            switch weight {
            case .ultraLight:
                systemFontName = "HelveticaNeue-UltraLight"
            case .light:
                systemFontName = "HelveticaNeue-Light"
            case .thin:
                systemFontName = "HelveticaNeue-Thin"
            case .normal:
                systemFontName = "HelveticaNeue"
            case .regular:
                systemFontName = "HelveticaNeue-Medium"
            case .semibold:
                systemFontName = "HelveticaNeue-Medium"
            case .bold:
                systemFontName = "HelveticaNeue-Bold"
            case .heavy:
                systemFontName = "HelveticaNeue-Bold"
            case .black:
                systemFontName = "HelveticaNeue-Bold"
            }
            
            return UIFont(name: systemFontName, size: CGFloat(size))!
        }
    }
    
}
