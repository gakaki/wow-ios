//
//  WOWSingPhoto.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation

class WOWSingPhoto {
    private static var __once: () = {
            Singleton.single=shareSingleTwo()
            }()
    //单例
    class func shareSingleTwo()->WOWSingPhoto{
        struct Singleton{
            static var onceToken : Int = 0
            static var single:WOWSingPhoto?
        }
        _ = WOWSingPhoto.__once
        return Singleton.single!
    }
   class func aaa() {
        print("111")
    }
}
