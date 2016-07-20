//
//  WOWApiPath.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

//Host
//王云鹏自己的本机 10.0.23.67        127.0.0.1
//测服地址 http://api.dev.wowdsgn.com


//#if WOWDEBUG
    let BaseUrl = "http://10.0.60.121:8080/mobile-api-dev/v1/" //开发
//#else
//    let BaseUrl = "http://10.0.60.121:8080/mobile-api-dev/v1/" //开发
//#endif

/****************************API_URL接口**********************************/

//1.app首页

let URL_category                = "category"

let URL_scene                   = "scene"

let URL_senceDetail             = "scene/detail"


//***********2.商店************
//2.1首页
let URL_storeHome               = "shop"
//2.2商品列表
let URL_product                 = "product"
//2.3商品详情
let URL_product_detail          = "product/detail"
//2.4发表评论
let URL_SubmitComment           = "comment/add"
//2.5评论列表
let URL_CommentList             = "comment"

//2.6收藏
let URL_Favorite                = "like/do"

let URL_BrandList               = "brand/list"

let URL_BrandDetail             = "brand/detail"

//3.app活动
let URL_activity                = "post"


//*********************4.购物车**********
// tag 为0 的时候 自增  为1的时候覆盖掉
let URL_CarEdit                 = "cart/update"

let URL_CarList                 = "cart/list"

let URL_CarNologin              = "cart/nologinlistandadd"

let URL_CarDelete               = "cart/del"

let URL_CarCommit               = "order/commit"


//5.个人中心
let URL_UpdateInfo              = "usermongo/userupdate"
let URL_FavoriteList            = "like/get"
let URL_UserInfo                = "usermongo/info"
let URL_Invite                  = "articleinfo"

//6.app 登录注册
let URL_Register                = "user/register"
let URL_login                   = "session/login"
let URL_Sms                     = "user/captcha"
let URL_ResetPassword           = "usermongo/resettingpwd"
let URL_Wechat                  = "session/login/wechat"          //微信登录
let URL_BlindWechat             = "user/wechat-bind"              //绑定微信
let URL_Logout                  = "session/logout"                //登出
let URL_Captcha                 = "user/captcha-for-wechat-bind"  //微信绑定获取验证码
let URL_Change                  = "user/change"                   //修改用户信息



let URL_AddressAdd              = "address/addorupdate"
let URL_AddressList             = "address/list"
let URL_AddressDelete           = "address/delete"

let URL_OrderList               = "order/list"

let URL_OrderStatus             = "order/setstatus" //状态客户端操作之后加上去




