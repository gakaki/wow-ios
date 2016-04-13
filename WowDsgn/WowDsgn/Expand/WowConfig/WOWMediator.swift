//
//  WOWMediator.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum GoodsDetailEntrance {
    case FromGoodsList
    case FromBrand
    case FromSence
}


struct WOWMediator {
    static var goodsDetailEntrance:GoodsDetailEntrance = .FromGoodsList
}