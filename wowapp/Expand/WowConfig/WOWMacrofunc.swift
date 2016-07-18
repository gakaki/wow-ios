//
//  WOWMacrofunc.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

let WOWDEBUG = true
public func DLog (value: Any , fileName : String = #file, line : Int32 = #line ){
    /// Debug Log
    if WOWDEBUG {
        print("file：\(NSURL(string: fileName)!.lastPathComponent!)  line：\(line) \(value)\n")
    }
}


/*
#file String The name of the file in which it appears.

#line Int The line number on which it appears.

#column Int The column number in which it begins.

#function String The name of the declaration in which it appears.
 */