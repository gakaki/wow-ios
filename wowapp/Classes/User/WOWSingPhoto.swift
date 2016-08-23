//
//  WOWSingPhoto.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation

class WOWSingPhoto {
    //单例
    class func shareSingleTwo()->WOWSingPhoto{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:WOWSingPhoto?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=shareSingleTwo()
            }
        )
        return Singleton.single!
    }
   class func aaa() {
        print("111")
    }
}
