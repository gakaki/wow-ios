//
//  WOWSingPhoto.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation

class WOWSingPhoto {
    
    struct Singleton{
        static var onceToken : Int = 0
        static var single:WOWSingPhoto?
    }
    //单例
    class func shareSingleTwo()->WOWSingPhoto{
        Singleton.single = shareSingleTwo()
        return Singleton.single!
    }
    class func aaa() {
        print("111")
    }
}
