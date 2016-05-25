//
//  WOWConfig.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

let WOWDSGNSCHEME       = "com.wow.dsgn"

//MARK:第三方Key
struct WOWID {
    
    struct Weibo {
        static let appID = "1279179552"
        static let appKey = "d0624f8a210a0e862ea581d2c6b6e507"
        static let redirectURL = "http://www.wowdsgn.com"
    }
    
    struct Wechat {
        static let appID = "wx5491e5203286430c"
        static let appKey = "4b58993541eeafdd8c236d15bfb15609"
    }
    
    struct UMeng {
        static let appID = "57146c72e0f55a807e000a0b"
    }
    
    struct LeanCloud {
        static let appID = "aSqukoQ9xLsQSMh0wHqbENH2-gzGzoHsz"
        static let appKey = "IGR5VQANuxRq3XsQnL9MYtyW"
    }
}



//MARK:WOW
public let WOWSizeScale:CGFloat = 1.2

/*
 空白的背景色 f5f5f5  245 245 245
 
 三级的title  128 128 128
 二级title    74 74 74
 一级title  0 0 0
 bordercolor 234 234 234
 分割线的颜色  234 234 234
 maskcolor  0 0 0 0.6
 */



//MARK:Color
/// 0
let GrayColorlevel1 = MGRgb(0, g: 0, b: 0)
/// 60
let GrayColorlevel2 = MGRgb(60, g: 60, b: 60)
 /// 128
let GrayColorlevel3 = MGRgb(128, g: 128, b: 128)
/// 240
let GrayColorlevel4 = MGRgb(240, g: 240, b: 240)
/// 250 同时也是tableView全局的背景颜色
let GrayColorLevel5 = MGRgb(245, g: 245, b: 245)

let ThemeColor = MGRgb(255, g: 230, b:0)

let BorderColor = MGRgb(200, g: 199, b: 204)

let SeprateColor = MGRgb(234, g:234, b: 234)

let MaskColor    = MGRgb(0, g: 0, b: 0, alpha: 0.6)

let DefaultBackColor = GrayColorLevel5


//MARK:Font
 /// 15号system字体
let Fontlevel001 = UIFont.systemScaleFontSize(15)
 /// 14号system字体
let Fontlevel002 = UIFont.systemScaleFontSize(14)
 /// 13号system字体
let Fontlevel003 = UIFont.systemScaleFontSize(13)
 /// 12号字体
let Fontlevel004 = UIFont.systemScaleFontSize(12)
 /// 11号字体
let FontLevel005 = UIFont.systemScaleFontSize(11)


/// 15号system字体
let FontMediumlevel001 = UIFont.mediumScaleFontSize(15)
/// 14号system字体
let FontMediumlevel002 = UIFont.mediumScaleFontSize(14)
/// 13号system字体
let FontMediumlevel003 = UIFont.mediumScaleFontSize(13)
/// 12号字体
let FontMediumlevel004 = UIFont.mediumScaleFontSize(12)



//MARK:Layer
func WOWBorderColor(view:UIView){
    view.borderColor(0.5, borderColor:SeprateColor)
}

func WOWBorderRadius(view:UIView){
    view.borderRadius(6)
}


