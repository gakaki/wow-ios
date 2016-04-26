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


/****************************API_URL接口**********************************/

//1.app首页

let URL_category               = "category"

let URL_scene                   = "scene"


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

//3.app活动
let URL_activity                = "post"



//4.个人中心
let URL_UpdateInfo              = "user/userupdate"

//5.app 登录注册
let URL_Register                = "user/register"
let URL_login                   = "user/login"

