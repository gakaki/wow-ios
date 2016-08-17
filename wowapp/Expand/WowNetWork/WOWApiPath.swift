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
   let BaseUrl = "http://10.0.60.121:8080/mobile-api-dev/v1/" //内网开发
//   let BaseUrl = "https://mobile-api.wowdsgn.com/v1/" //内网开发
//#else
//   let BaseUrl = "https://openapi.wowdsgn.com/v1/" //外网地址
//#endif

/****************************API_URL接口**********************************/

//1.app首页

let URL_category                = "category/sub-category"
let URL_producty_by_category    = "category/product"

let URL_scene                   = "scene"

let URL_senceDetail             = "scene/detail"


//***********2.商店************
//2.1首页
let URL_storeHome               = "shop"

let URL_home_banners            = "page/banners"    //1.1首页 查看首页Banner
let URL_home_scenes             = "page/scenes"     //1.2首页 查看首页场景
let URL_home_topics             = "page/topics"     //1.3首页 查看首页专题

//2.2商品列表
let URL_product                 = "product"
//2.3商品详情
let URL_product_detail          = "product"
//产品图文详情
let URL_Product_imageDetail     = "product/images/detail"
//2.4发表评论
let URL_SubmitComment           = "comment/add"
//2.5评论列表
let URL_CommentList             = "comment"

let URL_ProductSpec             = "product/spec"    //选择产品颜色规格

//2.6收藏
let URL_IsFavoriteProduct       = "user/product/is-favorite"   //是否喜欢某个单品

let URL_IsFavoriteBrand         = "user/brand/is-favorite"      //是否喜欢某个品牌

let URL_IsFavoriteDesigner      = "user/designer/is-favorite"      //是否喜欢某个品牌

let URL_FavoriteProduct         = "user/product/favorite"   //收藏单品

let URL_FavoriteBrand           = "user/brand/favorite"   //收藏单品

let URL_FavoriteDesigner        = "user/designer/favorite"   //收藏单品

let URL_BrandList               = "brand/list"

let URL_BrandDetail             = "brand/detail"

let URL_ProductBrand            = "product/brand"                //查询品牌产品

let URL_LikeProduct             = "user/product/favorite-list"    //喜欢的品牌列表

let URL_LikeDesigner            = "user/designer/favorite-list"    //喜欢的品牌列表

let URL_LikeBrand               = "user/brand/favorite-list"    //喜欢的品牌列表

let URL_DesignerDetail          = "designer/detail"         //设计师详情

let URL_ProductDesigner         = "product/designer"            //设计师产品
//3.app活动
let URL_activity                = "post"


//*********************4.购物车**********
// tag 为0 的时候 自增  为1的时候覆盖掉
let URL_CartModify               = "cart/modify"

let URL_CartList                 = "cart/list"

let URL_CartNologin              = "cart/nologinlistandadd"

let URL_CartRemove               = "cart/remove" //删除购物车商品

let URL_CartCommit               = "order/commit"

let URL_CartAdd                  = "cart/add"        //添加购物车

let URL_CartGet                  = "cart/get"        //查询购物车列表

let URL_CartSelect              = "cart/select"     //选中购物车商品

let URL_CartUnSelect            = "cart/unselect"   //取消选中购物车商品

//订单相关
let URL_OrderSettle             = "order/settle"            //查询订单内的物品

let URL_OrderBuyNow             = "order/buyNow"             //立即购买查询信息

let URL_OrderCreat              = "order/create"           //创建订单


let URL_OrderCharge             = "pay/charge"             //获取支付交易凭证

let URL_OrderDetail              = "order/getDetail"           //订单详情



let URL_PayResult               = "pay/payResult"          //查询支付结果

let URL_OrderConfirm            = "order/confirm"           //确认收货
//4. 发现页面
let URL_Found_Main              = "page/find/product"       
let URL_Found_2nd               = "page/find/category"

//5.个人中心
let URL_UpdateInfo              = "usermongo/userupdate"
let URL_FavoriteList            = "like/get"
let URL_UserInfo                = "usermongo/info"
let URL_Invite                  = "articleinfo"
let URL_QINIU_TOKEN             = "qiniutoken"


//6.app 登录注册
let URL_Register                = "user/register"
let URL_login                   = "session/login"
let URL_Sms                     = "user/captcha/register"
let URL_ResetPassword           = "user/reset-password"
let URL_Wechat                  = "session/login/wechat"          //微信登录
let URL_WechatBind              = "user/wechat-bind"              //绑定微信
let URL_Logout                  = "session/logout"                //登出
let URL_Captcha                 = "user/captcha/wechat-bind"      //微信绑定获取验证码
let URL_PwpResetCode            = "user/captcha/pwd-reset"        //重置密码获取验证码
let URL_Change                  = "user/change"                   //修改用户信息


//7.地址
let URL_AddressAdd              = "user/shippinginfo/create"   //添加收货地址
let URL_AddressList             = "user/shippinginfo/list"
let URL_AddressDelete           = "user/shippinginfo/delete"
let URL_AddressSetDefault       = "user/shippinginfo/set-default" //设为默认收货地址
let URL_AddressDefault          = "user/shippinginfo/default"   //查询默认收货地址
let URL_AddressEdit             = "user/shippinginfo/update"    //编辑收货地址

let URL_OrderList               = "order/get"

let URL_OrderStatus             = "order/setstatus" //状态客户端操作之后加上去

let URL_Coupon                  = "coupon/list" //优惠券列表


