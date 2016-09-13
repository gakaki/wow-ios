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

let WOWCompanyUrl                       = "http://www.wowdsgn.com/"

let WOWShareUrl                         = "m.wowdsgn.com"

/***********************************Const**********************************/
//拉取分类配置文件之后  进行回调更新操作
let WOWCategoryUpdateNotificationKey    = "WOWCategoryUpdateNotificationKey"

let WOWGoodsSureBuyNotificationKey      = "WOWGoodsSureBuyNotificationKey"

let WOWGoodsSureAddCarNotificationKey   = "WOWGoodsSureAddCarNotificationKey"

//跳到登录
let  WOWToLoginNotificationKey          = "WOWToLoginNotificationKey"

//登录成功
let  WOWLoginSuccessNotificationKey     = "WOWLoginSuccessNotificationKey"

//修改信息成功，更新主界面的信息
let  WOWChangeUserInfoNotificationKey     = "WOWChangeUserInfoNotificationKey"

//刷新喜欢列表
let  WOWRefreshFavoritNotificationKey     = "WOWRefreshFavoritNotificationKey"

//退出登录
let WOWExitLoginNotificationKey         = "WOWExitLoginNotificationKey"

//更新购物车，更新badge
let WOWUpdateCarBadgeNotificationKey    = "WOWUpdateCarBadgeNotificationKey"

//更新用户头像之后 更新user home页面的头像
let WOWUpdateUserHeaderImageNotificationKey  = "WOWUpdateUserHeaderImageNotificationKey"

//更新订单状态之后， 更新订单全部列表的信息
let WOWUpdateOrderListAllNotificationKey  = "WOWUpdateOrderListAllNotificationKey"


let WOWEmptyNetWorkText  = "网络错误"

let WOWEmptyNoDataText   = "暂无数据"


/***********************************Test***************************************/
let WOWTestStr = "不可救药的理想主义者"



typealias WOWActionClosure         = () -> ()
typealias WOWObjectActionClosure   = (object:AnyObject) ->()

let WOWConstellation:[Int:String] = [1:"白羊座",2:"金牛座",3:"双子座",4:"巨蟹座",5:"狮子座",6:"处女座",7:"天秤座",8:"天蝎座",9:"射手座",10:"摩羯座",11:"水瓶座",12:"双鱼座"]

let WOWAgeRange:[Int:String] = [0:"保密", 1:"60后", 2:"70后", 3:"80后", 4:"85后", 5:"90后", 6:"95后", 7:"00后"]

let WOWSex:[Int:String] = [1:"男",2:"女",3:"保密"]


//let WOWTestUID   = "20"