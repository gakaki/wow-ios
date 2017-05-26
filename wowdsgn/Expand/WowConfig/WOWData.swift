//
//  WOWData.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

//let WOWRealm = try! Realm()



//let WOWMenus = ["所有商品","家什","灯光","装点","食居","童趣"]

let WOWCompanyUrl                       = "http://www.wowdsgn.com/"


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

//更新专题点赞数
let WOWUpdateProjectThumbNotificationKey  = "WOWUpdateProjectThumbNotificationKey"

//更新筛选条件
let WOWUpdateScreenConditionsKey  = "WOWUpdateProjectThumbNotificationKey"

let WOWEmptyNetWorkText  = "网络错误"

let WOWEmptyNoDataText   = "暂无数据"


/***********************************Test***************************************/
let WOWTestStr = "不可救药的理想主义者"
let WowShareText = "尖叫设计，生活即风格 - 即刻下载app，领取新人专享礼包！"


typealias WOWActionClosure         = () -> ()
typealias WOWObjectActionClosure   = (_ object:AnyObject) ->()

let WOWConstellation:[Int:String] = [1:"白羊座",2:"金牛座",3:"双子座",4:"巨蟹座",5:"狮子座",6:"处女座",7:"天秤座",8:"天蝎座",9:"射手座",10:"摩羯座",11:"水瓶座",12:"双鱼座"]

let WOWAgeRange:[Int:String] = [0:"保密", 1:"60后", 2:"70后", 3:"80后", 4:"85后", 5:"90后", 6:"95后", 7:"00后"]

let WOWSex:[Int:String] = [1:"男",2:"女",3:"保密"]

let RefundTextArray:[Int:String] = [1:"尺码拍错／不喜欢／不想要",2:"空包裹",3:"未按约定时间发货",4:"快递／物流一直未送到",5:"退运费",6:"做工有瑕疵",7:"质量问题（开胶／掉色)",8:"尺寸／功能／颜色／款式与商品描述不符",9:"少件／漏发",10:"卖家发错货",11:"包装／商品破损／污渍／变形",12:"未按约定时间发货",13:"7天无理由退换货",14:"平台发错货"]

let RefundArray:[[Any]] = [[1,"尺码拍错／不喜欢／不想要"],[2,"空包裹"],[3,"未按约定时间发货"],[4,"快递／物流一直未送到"],[5,"退运费"],[6,"做工有瑕疵"],[7,"质量问题（开胶／掉色)"],[8,"尺寸／功能／颜色／款式与商品描述不符"],[9,"少件／漏发"],[10,"卖家发错货"],[11,"包装／商品破损／污渍／变形"],[12,"未按约定时间发货"],[13,"7天无理由退换货"],[14,"平台发错货"]]

let WOWOnlyRefund           = [RefundArray[0]]
let WOWOnlyRefundNoReceived = [RefundArray[0],RefundArray[1],RefundArray[2],RefundArray[3]]
let WOWOnlyRefundReceived   = [RefundArray[0],RefundArray[4],RefundArray[5],RefundArray[6],RefundArray[7],RefundArray[8],RefundArray[9],RefundArray[10],RefundArray[11]]
let WOWRefundAllReceived    = [RefundArray[12],RefundArray[4],RefundArray[5],RefundArray[6],RefundArray[7],RefundArray[8],RefundArray[9],RefundArray[10]]
let WOWReturnGoodsReceived  = [RefundArray[0],RefundArray[13],RefundArray[5],RefundArray[6],RefundArray[7],RefundArray[9],RefundArray[10]]

let WOWCompanyArray         = [ // 快递公司名称 与 WOWCompanyCodeArray  一一对应
    "顺丰速运",
    "日日顺",
    "全峰",
    "韵达",
    "中通",
    "天天",
    "百世汇通",
    "宅急送",
    "德邦",
    "新邦",
    "申通",
    "圆通速递",
    "优速快递",
    "EMS",
    "苏宁快递",
    "全一快递",
    "其他"
    ]

let WOWCompanyCodeArray         = [ // 快递公司代码 传后台参数时使用
    "shunfeng",
    "rrs",
    "quanfengkuaidi",
    "yunda",
    "zhongtong",
    "tiantian",
    "baishiwuliu",
    "zhaijisong",
    "debangwuliu",
    "xinbangwuliu",
    "shentong",
    "yuantong",
    "yousu",
    "EMS",
    "suning",
    "quanyi",
    "qita"
]








