//
//  UINib+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension UINib{
    
    class func nibName(name:String) ->UINib{
        return UINib(nibName: name, bundle: NSBundle.mainBundle())
    }
}