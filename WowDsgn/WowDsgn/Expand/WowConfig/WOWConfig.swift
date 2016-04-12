//
//  WOWConfig.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

//MARK:第三方Key
let UMKey = "56ebe0a867e58e33e300228e"



//MARK:WOW
public let WOWSizeScale:CGFloat = 1.2

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
let GrayColorLevel5 = MGRgb(250, g: 250, b: 250)

let ThemeColor = MGRgb(255, g: 230, b:0)

let BorderColor = MGRgb(200, g: 199, b: 204)


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
    view.borderColor(0.5, borderColor:BorderColor)
}

func WOWBorderRadius(view:UIView){
    view.borderRadius(6)
}


