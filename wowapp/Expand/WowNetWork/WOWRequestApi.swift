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
    
    case Api_Activity
    
    case Api_AddressAdd(receiverName:String,provinceId:String,cityId:String,addressDetail:String,receiverMobile:String,isDefault:String)
    
    case Api_Addresslist
    
    case Api_AddressDelete(uid:String,addressid:String)
    
    case Api_SenceDetail(sceneid:String,uid:String)
    
    case Api_BrandList
    
    case Api_BrandDetail(brandid:String)
    
    case Api_Category
    
    case Api_Captcha(mobile:String) //绑定微信验证码
    
    case Api_CarEdit(cart:String)
    
    case Api_CarList(cart:String)
    
    case Api_CarNologin(cart:String)
    
    case Api_CarDelete(cart:String)
    
    case Api_CarCommit(car:String)
    
    case Api_CommentList(pageindex:String,thingid:String,type:String)
    
    case Api_Change(param:[String:String])
    
    case Api_Favotite(product_id:String,uid:String,type:String,is_delete:String,scene_id:String)

    case Api_Invite //邀请好友
    
    case Api_Login(String,String)
    
    case Api_OrderList(uid:String,type:String) //100为全部
    
    case Api_OrderStatus(uid:String,order_id:String,status:String)
    
    case Api_ProductList(pageindex:String,categoryID:String,style:String,sort:String,uid:String,keyword:String)
    
    case Api_ProductDetail(product_id:String,uid:String)
    
    case Api_PwdResetCode(mobile:String) //重置密码获取验证码
    
    case Api_Register(account:String,password:String,captcha:String)
    
    case Api_ResetPwd(mobile:String,code:String,password:String)
    
    case Api_StoreHome
    
    case Api_SubmitComment(uid:String,comment:String,thingid:String,type:String)

    
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
        case .Api_BrandList:
            return URL_BrandList
        case .Api_BrandDetail:
            return URL_BrandDetail
        case .Api_Favotite:
            return URL_Favorite
        case .Api_CommentList:
            return URL_CommentList
        case .Api_SubmitComment:
            return URL_SubmitComment
        case .Api_CarEdit:
            return URL_CarEdit
        case .Api_UserUpdate:
            return URL_UpdateInfo
        case .Api_CarList:
            return URL_CarList
        case .Api_UserFavorite:
            return URL_FavoriteList
        case .Api_CarNologin:
            return URL_CarNologin
        case .Api_CarDelete:
            return URL_CarDelete
        case .Api_Change:
            return URL_Change
        case .Api_CarCommit:
            return URL_CarCommit
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
        case .Api_AddressAdd:
            return URL_AddressAdd
        case .Api_Addresslist:
            return URL_AddressList
        case .Api_AddressDelete:
            return URL_AddressDelete
        case .Api_OrderList:
            return URL_OrderList
        case .Api_OrderStatus:
            return URL_OrderStatus
        case .Api_Invite:
            return URL_Invite
        }
    }
    
    public var method:Moya.Method{
        switch self {
        case .Api_Addresslist,.Api_Home_Banners:
            return .GET
        default:
            return .POST
        }
        
    }
    
    
    
    public var parameters:[String: AnyObject]?{
        var params = [String: AnyObject]?()
        switch self{
            case let .Api_SenceDetail(sceneid,uid):
                params = ["scene_id":sceneid,"uid":uid]
            case let .Api_Register(account,password,code):
                params = ["mobile":account,"password":password,"captcha":code]
            case let .Api_Login(account,password):
                params = ["mobile":account,"password":password]
            case let .Api_BrandDetail(brandid):
                params = ["brandid":brandid]
            case let .Api_ProductList(pageindex,categoryID,style,sort,uid,keyword):
                params = ["pageindex":pageindex,"cid":categoryID,"style":style,"sort":sort,"uid":uid,"keyword":keyword]
            case let .Api_ProductDetail(product_id,uid):
                params = ["id":product_id,"uid":uid]
            case let .Api_Favotite(product_id,uid,type,is_delete,scene_id):
                params = ["uid":uid,"product_id":product_id,"type":type,"is_delete":is_delete,"scene_id":scene_id]
            case let .Api_CommentList(pageindex,thingid,type):
                params = ["pageindex":pageindex,"thingid":thingid,"type":type]
            case let .Api_SubmitComment(uid,comment,thingid,type):
                params =  ["uid":uid,"thingid":thingid,"comment":comment,"type":type]
            case let .Api_UserUpdate(param):
                params =  param
            case let .Api_UserFavorite(uid,type,pageindex):
                params =  ["uid":uid,"type":type,"pageindex":pageindex]
            case let .Api_CarEdit(cart):
                params =  ["cart":cart]
            case let .Api_CarList(cart):
                params =  ["cart":cart]
            case let .Api_CarNologin(cart):
                params =  ["cart":cart]
            case let .Api_CarDelete(cart):
                params =  ["cart":cart]
            case let .Api_CarCommit(cart):
                params =  ["cart":cart]
            case let .Api_Change(param):
                params = param
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
                params =  ["mobile":mobile,"code":code,"password":password]
            case let .Api_AddressAdd(receiverName,provinceId,cityId,addressDetail,receiverMobile,isDefault):
                params =  ["receiverName":receiverName,"provinceId":provinceId,"cityId":cityId,"addressDetail":addressDetail,"receiverMobile":receiverMobile,"isDefault":isDefault]
            case .Api_Addresslist:
                break
            case let .Api_AddressDelete(uid,id):
                params =  ["uid":uid,"id":id]
            case let .Api_OrderList(uid,type):
                params =  ["uid":uid,"type":type]
            case let .Api_OrderStatus(uid,order_id,status):
                params =  ["uid":uid,"order_id":order_id,"status":status]
            
            
            case .Api_Home_Banners():
                params =  ["pageType":1]
            case  .Api_Home_Scenes():
                params =  ["pageType":1]
            case  .Api_Home_Topics():
                params =  ["pageType":1]
            
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
        case .Api_CarEdit:
            return ""
        case .Api_CarList,.Api_ProductList:
            return ""
        default:
            return ""
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}