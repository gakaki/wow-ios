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

let BaseUrl = "http://api.dev.wowdsgn.com/apiv1/"
//let BaseUrl = "http://127.0.0.1:8360/apiv1/"

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
let URL_SubmitComment           = "product/comment"
//2.5评论列表
let URL_CommentList             = "product/commentlist"

//2.6收藏
let URL_Favorite                = "favorite/like"

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
let URL_UpdateInfo              = "user/userupdate"
let URL_FavoriteList            = "like/get"

//6.app 登录注册
let URL_Register                = "usermongo/register"
let URL_login                   = "usermongo/login"
let URL_Sms                     = "sms/getcode"
let URL_ResetPassword           = "user/resettingpwd"


let URL_AddressAdd              = "address/addorupdate"
let URL_AddressList             = "address/list"
let URL_AddressDelete           = "address/delete"
