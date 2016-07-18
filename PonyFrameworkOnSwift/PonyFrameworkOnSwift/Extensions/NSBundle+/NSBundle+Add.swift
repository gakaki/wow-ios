//
//  NSBundle+Add.swift
//  WowLib
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension NSBundle{
    static func loadResourceName(name:String!) -> AnyObject?{
        return  NSBundle.mainBundle().loadNibNamed(name, owner: self, options: nil).last
    }
}