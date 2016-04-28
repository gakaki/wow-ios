//
//  WOWData.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

let WOWRealm = try! Realm()



//let WOWMenus = ["所有商品","家什","灯光","装点","食居","童趣"]



/***********************************Const**********************************/
//拉取分类配置文件之后  进行回调更新操作
let WOWCategoryUpdateNotificationKey    = "WOWCategoryUpdateNotificationKey"

let WOWGoodsSureBuyNotificationKey      = "WOWGoodsSureBuyNotificationKey"

//登录成功
let  WOWLoginSuccessNotificationKey     = "WOWLoginSuccessNotificationKey"

//退出登录
let WOWExitLoginNotificationKey         = "WOWExitLoginNotificationKey"


let WOWEmptyNetWorkText  = "网络错误"

let WOWEmptyNoDataText   = "暂无数据"


/***********************************Test***************************************/
let WOWTestStr = "不可救药的理想主义者"



typealias WOWAction = () -> ()