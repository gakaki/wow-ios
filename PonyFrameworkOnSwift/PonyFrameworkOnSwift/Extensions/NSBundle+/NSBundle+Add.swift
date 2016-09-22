//
//  NSBundle+Add.swift
//  WowLib
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension Bundle{
    static func loadResourceName(_ name:String!) -> AnyObject?{
        return  Bundle.main.loadNibNamed(name, owner: self, options: nil)?.last as AnyObject?
    }
}
