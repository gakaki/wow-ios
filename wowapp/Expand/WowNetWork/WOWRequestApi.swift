//
//  WOWRequestApi.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public enum RequestApi{
    
    
    static var HostUrl:String! = BaseUrl
    
    case Api_Sence
    
    //Tab 第一个栏 首页 该死的那3个url
    case Api_Home_Banners
    case Api_Home_Scenes
    case Api_Home_Topics
    
    //发现 分类 页面
    case Api_Found_Main
    case Api_Found_2nd
    
    
    case Api_Activity
    
    case Api_AddressAdd(receiverName: String, provinceId: Int, cityId: Int, countyId: Int, addressDetail: String, receiverMobile: String, isDefault:Bool)
    
    case Api_Addresslist
    
    case Api_AddressDelete(id:Int)
    
    case Api_AddressSetDefault(id:Int)
    
    case Api_AddressDefault
    
    case Api_AddressEdit(id: Int, receiverName: String, provinceId: Int, cityId: Int, countyId: Int, addressDetail: String, receiverMobile: String, isDefault:Bool)
    
    case Api_SenceDetail(sceneid:String,uid:String)
    
    //品牌
    case Api_BrandList
    
    case Api_BrandDetail(brandId: Int)
    
    case Api_ProductBrand(brandId: Int)
    //设计师
    case Api_DesignerDetail(designerId: Int)
    
    case Api_productDesigner(designerId: Int)
    
    
    case Api_Category(categoryId:String) //查看分类
    case Api_Product_By_Category(asc:Int , currentPage: Int, showCount :Int , sortBy:Int, categoryId:Int ) //查看分类下商品 asc 0 降序 当前页 showCount  sortBy 1 categoryId

    case Api_Captcha(mobile:String) //绑定微信验证码
    
    //购物车相关
    case Api_CartModify(shoppingCartId:Int, productQty:Int)
    
    case Api_CartList(cart:String)
    
    case Api_CartNologin(cart:String)
    
    case Api_CartRemove(shoppingCartId:[Int])
    
    case Api_CartCommit(car:String)
    
    case Api_CartAdd(productId: Int, productQty: Int)
    
    case Api_CartGet
    
    case Api_CartSelect(shoppingCartIds: [Int])
    
    case Api_CartUnSelect(shoppingCartIds: [Int])
    
    
    case Api_CommentList(pageindex:String,thingid:Int,type:String)
    
    case Api_Change(param:[String:String])
    
    //用户收藏相关
    case Api_FavoriteProduct(productId: Int)
    
    case Api_FavoriteBrand(brandId: Int)
    
    case Api_FavoriteDesigner(designerId: Int)
    
    case Api_IsFavoriteProduct(productId: Int)
    
    case Api_IsFavoriteBrand(brandId: Int)
    
    case Api_IsFavoriteDesigner(designerId: Int)
    
    case Api_LikeProduct
    
    case Api_LikeBrand
    
    case Api_LikeDesigner
    
    
    
    case Api_Invite //邀请好友
    
    case Api_Login(String,String)
    
    //订单相关
    

//    case Api_OrderList(uid:String,type:String) //100为全部
    case Api_OrderList(orderStatus:String,currentPage:Int,pageSize:Int)

    case Api_OrderDetail(OrderCode:String)

    
    case Api_OrderStatus(uid: String, order_id: String, status: String)
    
    case Api_OrderSettle
    
    case Api_OrderBuyNow(productId: Int, productQty: Int)
    
    case Api_OrderCreate(params: [String: AnyObject]?)
    
    case Api_OrderCharge(orderNo: String, channel: String, clientIp: String)
    
    case Api_PayResult(orderCode: String)
    
    case Api_OrderConfirm(orderCode: String)
//
    
    case Api_ProductList(pageindex:String,categoryID:String,style:String,sort:String,uid:String,keyword:String)
    
    case Api_ProductDetail(productId: Int)
    
    case Api_ProductImgDetail(productId: Int)
    
    case Api_ProductSpec(productId: Int)
    
    case Api_PwdResetCode(mobile:String) //重置密码获取验证码
    
    case Api_Register(account:String,password:String,captcha:String)
    
    case Api_ResetPwd(mobile:String,captcha:String,newPwd:String)
    
    case Api_StoreHome
    
    case Api_SubmitComment(uid:String,comment:String,thingid:Int,type:String)

    
    case Api_Sms(type:String,mobile:String) //type = 1注册  type = 2更改验证码
    
    case Api_Sms_Code(mobile:String) //验证码
    
    case Api_UserUpdate(param:[String:String])
    
    case Api_UserFavorite(uid:String,type:String,pageindex:String)

    case Api_Wechat(openId:String) //openId
    
    case Api_WechatBind(mobile:String,captcha:String,password:String,userInfoFromWechat:AnyObject)

}


extension RequestApi:TargetType{
    public var baseURL:NSURL{
        return NSURL(string: RequestApi.HostUrl)!
    }
    
    public var path:String{
        switch self{
        case .Api_Category:
            return URL_category
        case .Api_Product_By_Category:
            return URL_producty_by_category
        case .Api_Activity:
            return URL_activity
        case .Api_StoreHome:
            return URL_storeHome
        case .Api_Sence:
            return URL_scene
        case .Api_SenceDetail:
            return URL_senceDetail
            
        //Tab 第一个栏 首页 该死的那3个url
        case .Api_Home_Banners:
            return URL_home_banners
        case .Api_Home_Scenes:
            return URL_home_scenes
        case .Api_Home_Topics:
            return URL_home_topics
            
        case .Api_ProductList:
            return URL_product
        case .Api_ProductDetail:
            return URL_product_detail
        case .Api_ProductImgDetail:
            return URL_Product_imageDetail
        case .Api_ProductSpec:
            return URL_ProductSpec
        case .Api_BrandList:
            return URL_BrandList
        case .Api_BrandDetail:
            return URL_BrandDetail
        case .Api_ProductBrand:
            return URL_ProductBrand
        case .Api_DesignerDetail:
            return URL_DesignerDetail
        case .Api_productDesigner:
            return URL_ProductDesigner
            
        case .Api_CommentList:
            return URL_CommentList
        case .Api_SubmitComment:
            return URL_SubmitComment
        //购物车相关
        case .Api_CartModify:
            return URL_CartModify
        case .Api_UserUpdate:
            return URL_UpdateInfo
        case .Api_CartList:
            return URL_CartList
        case .Api_CartAdd:
            return URL_CartAdd
        case .Api_CartGet:
            return URL_CartGet
        case .Api_CartNologin:
            return URL_CartNologin
        case .Api_CartRemove:
            return URL_CartRemove
        case .Api_CartCommit:
            return URL_CartCommit
        case .Api_CartSelect:
            return URL_CartSelect
        case .Api_CartUnSelect:
            return URL_CartUnSelect
            
        //收藏相关
        case .Api_UserFavorite:
            return URL_FavoriteList
        case .Api_FavoriteProduct:
            return URL_FavoriteProduct
        case .Api_FavoriteBrand:
            return URL_FavoriteBrand
        case .Api_FavoriteDesigner:
            return URL_FavoriteDesigner
        case .Api_IsFavoriteProduct:
            return URL_IsFavoriteProduct
        case .Api_IsFavoriteBrand:
            return URL_IsFavoriteBrand
        case .Api_IsFavoriteDesigner:
            return URL_IsFavoriteDesigner
        case .Api_LikeProduct:
            return URL_LikeProduct
        case .Api_LikeBrand:
            return URL_LikeBrand
        case .Api_LikeDesigner:
            return URL_LikeDesigner
            
        case .Api_Login:
            return URL_login
        case .Api_Register:
            return URL_Register
        case .Api_Sms:
            return URL_Sms
        case .Api_Sms_Code:
            return URL_Sms
        case .Api_Captcha:
            return URL_Captcha
        case .Api_PwdResetCode:
            return URL_PwpResetCode
        case .Api_Wechat:
            return URL_Wechat
        case .Api_WechatBind:
            return URL_WechatBind
        case .Api_ResetPwd:
            return URL_ResetPassword
        case .Api_Change:
            return URL_Change
            
        case .Api_AddressAdd:
            return URL_AddressAdd
        case .Api_Addresslist:
            return URL_AddressList
        case .Api_AddressDelete:
            return URL_AddressDelete
        case .Api_AddressSetDefault:
            return URL_AddressSetDefault
        case .Api_AddressEdit:
            return URL_AddressEdit
        case .Api_AddressDefault:
            return URL_AddressDefault
            
        //订单相关
        case .Api_OrderList:
            return URL_OrderList
        case .Api_OrderStatus:
            return URL_OrderStatus
        case .Api_OrderSettle:
            return URL_OrderSettle
        case .Api_OrderBuyNow:
            return URL_OrderBuyNow
        case .Api_OrderCreate:
            return URL_OrderCreat
        case .Api_OrderCharge:
            return URL_OrderCharge
        case .Api_OrderDetail:
            return URL_OrderDetail
        case .Api_PayResult:
            return URL_PayResult
        case .Api_OrderConfirm:
            return URL_OrderConfirm
            
        case .Api_Invite:
            return URL_Invite
        //发现页面
        case .Api_Found_Main:
            return URL_Found_Main
        case .Api_Found_2nd:
            return URL_Found_2nd

        }
    }
    
    public var method:Moya.Method{
        switch self {

        case .Api_Addresslist, Api_BrandList, .Api_Home_Banners, .Api_LikeBrand, .Api_LikeProduct, .Api_LikeDesigner, .Api_IsFavoriteProduct, .Api_IsFavoriteBrand, .Api_IsFavoriteDesigner, .Api_ProductDetail, .Api_ProductImgDetail, .Api_ProductSpec, .Api_OrderList,.Api_CartGet, .Api_AddressDefault, .Api_OrderSettle, .Api_BrandDetail, .Api_ProductBrand, .Api_Found_Main , .Api_Found_2nd, .Api_DesignerDetail, .Api_productDesigner, .Api_Category, .Api_PayResult, .Api_OrderDetail , .Api_Product_By_Category:

            return .GET

        default:
            return .POST
        }
        
    }
    
    
    
    public var parameters:[String: AnyObject]?{
        var params = [String: AnyObject]?()
        switch self{
            case let .Api_Category(categoryId):
                params = ["categoryId":categoryId]
            case let .Api_SenceDetail(sceneid,uid):
                params = ["scene_id":sceneid,"uid":uid]
            case let .Api_Register(account,password,code):
                params = ["mobile":account,"password":password,"captcha":code]
            case let .Api_Login(account,password):
                params = ["mobile":account,"password":password]
            case let .Api_BrandDetail(brandid):
                params = ["brandId": brandid]
            case let .Api_ProductBrand(brandId):
                params = ["brandId": brandId]
            case let .Api_DesignerDetail(designerId):
                params = ["designerId": designerId]
            case let .Api_productDesigner(designerId):
                params = ["designerId": designerId]
            case let .Api_ProductList(pageindex,categoryID,style,sort,uid,keyword):
                params = ["pageindex":pageindex,"cid":categoryID,"style":style,"sort":sort,"uid":uid,"keyword":keyword]
            case let .Api_ProductDetail(productId):
                params = ["productId":productId]
            case let .Api_ProductImgDetail(productId):
                params = ["productId":productId]
            case let .Api_ProductSpec(productId):
                params = ["productId":productId]
            case let .Api_CommentList(pageindex,thingid,type):
                params = ["pageindex":pageindex,"thingid":thingid,"type":type]
            case let .Api_SubmitComment(uid,comment,thingid,type):
                params =  ["uid":uid,"thingid":thingid,"comment":comment,"type":type]
            case let .Api_UserUpdate(param):
                params =  param
            case let .Api_UserFavorite(uid,type,pageindex):
                params =  ["uid":uid,"type":type,"pageindex":pageindex]
            
            case let .Api_CartModify(shoppingCartId, productQty):
                params =  ["shoppingCartId": shoppingCartId, "productQty": productQty]
            case let .Api_CartList(cart):
                params =  ["cart":cart]
            case let .Api_CartNologin(cart):
                params =  ["cart":cart]
            case let .Api_CartRemove(shoppingCartId):
                params =  ["shoppingCartIds":shoppingCartId]
            case let .Api_CartCommit(cart):
                params =  ["cart":cart]
            case let .Api_CartAdd(productId, productQty):
                params =  ["productId": productId, "productQty": productQty]
            case let .Api_CartSelect(shoppingCartIds):
                params = ["shoppingCartIds": shoppingCartIds]
            case let .Api_CartUnSelect(shoppingCartIds):
                params = ["shoppingCartIds": shoppingCartIds]

            
            case let .Api_Change(param):
                params = param
            //用户喜欢相关
            case let .Api_FavoriteProduct(productId):
                params = ["productId":productId]
            case let .Api_FavoriteBrand(brandId):
                params = ["brandId":brandId]
            case let .Api_FavoriteDesigner(designerId):
                params = ["designerId":designerId]
            case let .Api_IsFavoriteProduct(productId):
                params = ["productId":productId]
            case let .Api_IsFavoriteBrand(brandId):
                params = ["brandId":brandId]
            case let .Api_IsFavoriteDesigner(designerId):
                params = ["designerId":designerId]
            
            case let .Api_Sms(type,mobile):
                params =  ["type":type,"mobile":mobile]
            case let .Api_Sms_Code(mobile):
                params =  ["mobile":mobile]
            case let .Api_Captcha(mobile):
                params =  ["mobile":mobile]
            case let .Api_PwdResetCode(mobile):
                params =  ["mobile":mobile]
            case let .Api_Wechat(openId):
                params =  ["openId":openId]
            case let .Api_WechatBind(mobile,captcha,password,userInfoFromWechat):
                params =  ["mobile":mobile,"captcha":captcha,"password":password,"userInfoFromWechat":userInfoFromWechat]
            case let .Api_ResetPwd(mobile, code, password):
                params =  ["mobile":mobile,"captcha":code,"newPwd":password]
            case let .Api_AddressAdd(receiverName, provinceId, cityId, countyId, addressDetail, receiverMobile, isDefault):
                params =  ["receiverName": receiverName, "provinceId": provinceId, "cityId": cityId, "countyId":countyId, "addressDetail": addressDetail, "receiverMobile": receiverMobile, "isDefault": isDefault]
            case .Api_Addresslist:
                break
            case let .Api_AddressDelete(id):
                params =  ["id":id]
            case let .Api_AddressSetDefault(id):
                params = ["id":id]
            case let .Api_AddressEdit(id, receiverName, provinceId, cityId, countyId, addressDetail, receiverMobile, isDefault):
                params = ["id": id, "receiverName": receiverName, "provinceId": provinceId, "cityId": cityId, "countyId":countyId, "addressDetail": addressDetail, "receiverMobile": receiverMobile, "isDefault": isDefault]
            
            //订单相关
            case let .Api_OrderList(orderStatus,currentPage,pageSize):
                params =  ["orderStatus":orderStatus,"currentPage":currentPage,"pageSize":pageSize]
            
            case let .Api_OrderStatus(uid,order_id,status):
                params =  ["uid":uid,"order_id":order_id,"status":status]
            case let .Api_OrderCreate(param):
                params = param
            case let .Api_OrderCharge(orderNo, channel, alientIp):
                params = ["orderNo": orderNo, "channel": channel, "clientIp": alientIp]
            case let .Api_OrderBuyNow(productId, productQty):
                params = ["productId": productId, "productQty": productQty]
            case let .Api_PayResult(orderCode):
                params = ["orderCode": orderCode]
            case let .Api_OrderConfirm(orderCode):
                params = ["orderCode": orderCode]
            case let .Api_OrderDetail(OrderCode):
                params =  ["orderCode":OrderCode]
            
            case .Api_Home_Banners():
                params =  ["pageType":1]
            case  .Api_Home_Scenes():
                params =  ["pageType":1]
            case  .Api_Home_Topics():
                params =  ["pageType":1]
            case .Api_Found_2nd:
                break
            case .Api_Found_Main:
                break

            case let .Api_Product_By_Category(asc , currentPage, showCount , sortBy, categoryId ): //查看分类下商品 asc 0 降序 当前页 showCount  sortBy 1 categoryId
                    params = ["asc": asc, "currentPage": currentPage, "showCount": showCount, "sortBy": sortBy, "categoryId":categoryId]
                    break
            
            default:
                params =  nil

        }
        params =   ["paramJson":JSONStringify(params ?? ""),"channel":"2","sessionToken":WOWUserManager.sessionToken]

        return params
    }
    
    
        /// 返回""空串的话代表需要在回调函数里面自己提示
    public var endSuccessMsg:String?{
        switch self {
        case .Api_Login:
            return "登录成功"
        case .Api_Register:
            return "注册成功"
        case .Api_SubmitComment:
            return "评论成功"
        case .Api_Sms:
            return "验证码发送成功"
        case .Api_AddressAdd:
            return ""
        case .Api_CartList,.Api_ProductList:
            return ""
        case .Api_CartAdd:
            return "添加购物车成功"
        case .Api_OrderConfirm:
            return "确认收货成功"
        default:
            return ""
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}