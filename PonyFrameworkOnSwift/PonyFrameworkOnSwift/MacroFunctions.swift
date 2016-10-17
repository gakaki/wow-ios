//
//  MacroFunctions.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/17.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import UIKit

public func MGRgb(_ r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1) -> UIColor{
    return UIColor(red:r/255.0, green: g/255.0, blue: b/255.0, alpha:alpha)
}



public func kkLog(){
    debugPrint("123")
}


public func MGFrame(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> CGRect{
    return CGRect(x: x, y: y, width: width, height: height)
}

public func MGNib(_ nibName:String) ->UINib{
    return UINib(nibName:nibName, bundle: Bundle.main)
}

public let MGScreenWidth:CGFloat = UIScreen.main.bounds.size.width
public let MGScreenHeight:CGFloat = UIScreen.main.bounds.size.height
public let MGScreenWidthHalf:CGFloat = MGScreenWidth / 2
public let MGScreenHeightHalf:CGFloat = MGScreenHeight / 2


//MARK:简写的实例化
public let MGDefault = UserDefaults.standard
public let MGNotificationCenter = NotificationCenter.default


//MARK:流水线加工控件

/**
流水线label
居中 背景白色label
- returns: 居中 背景白色label 14号字体 字体颜色60，60，60  单行
*/
public func MGfactoryLabel() -> UILabel{
    let label = UILabel()
    label.textAlignment = .center
    label.backgroundColor = UIColor.white
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 1
    label.textColor = MGRgb(60, g: 60, b: 60)
    return label
}

/**
 流水线View
 背景白色
 */
public func MGfactoryView() -> UIView{
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
}

public func MGFactoryButton() ->UIButton{
    let view = UIButton()
    return view
}



