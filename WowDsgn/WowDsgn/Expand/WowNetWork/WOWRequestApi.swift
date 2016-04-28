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
    
    case Api_Sence(String,Int)
    
    case Api_Category
    
    case Api_Activity
    
    case Api_StoreHome
    
    case Api_ProductList(pageindex:String,categoryID:String,style:String,sort:String)
    
    case Api_ProductDetail(product_id:String)
    
    case Api_CommentList(pageindex:String,product_id:String)
    
    case Api_SubmitComment(uid:String,comment:String,product_id:String)
    
    case Api_CarEdit(cart:String)
    
    case Api_CarList(cart:String)
    
    case Api_CarNologin(cart:String)
    
    case Api_CarDelete(cart:String)
    
    case Api_UserUpdate(param:[String:String])
    
    case Api_Login(String,String)
    
    case Api_Register(account:String,password:String)
    
    case Api_Sms(type:String,mobile:String) //type = 1注册  type = 2更改验证码
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
        case .Api_ProductList:
            return URL_product
        case .Api_ProductDetail:
            return URL_product_detail
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
        case .Api_CarNologin:
            return URL_CarNologin
        case .Api_CarDelete:
            return URL_CarDelete
        case .Api_Login:
            return URL_login
        case .Api_Register:
            return URL_Register
        case .Api_Sms:
            return URL_Sms
            
        }
    }
    
    public var method:Moya.Method{
        return .POST
    }
    
    public var parameters:[String: AnyObject]?{
        switch self{
        case let .Api_Sence(_, value):
            return ["pageIndex":String(value)]
        case let .Api_Register(account,password):
            return ["account":account,"password":password]
        case let .Api_Login(account,password):
            return ["account":account,"password":password]
        case let .Api_ProductList(pageindex,categoryID,style,sort):
            return ["z":pageindex,"cid":categoryID,"style":style,"sort":sort]
        case let .Api_ProductDetail(product_id):
            return ["id":product_id]
        case let .Api_CommentList(pageindex,product_id):
            return ["pageindex":pageindex,"product_id":product_id]
        case let .Api_SubmitComment(uid,comment,product_id):
            return ["uid":uid,"product_id":product_id,"comment":comment]
        case let .Api_UserUpdate(param):
            return param
        case let .Api_CarEdit(cart):
            return ["cart":cart]
        case let .Api_CarList(cart):
            return ["cart":cart]
        case let .Api_CarNologin(cart):
            return ["cart":cart]
        case let .Api_CarDelete(cart):
            return ["cart":cart]
        case let .Api_Sms(type,mobile):
            return ["type":type,"mobile":mobile]
        default:
            return nil
        }
    }
    
    
    public var endSuccessMsg:String?{
        switch self {
        case .Api_Login:
            return "登录成功"
        case .Api_Register:
            return "注册成功"
        case .Api_SubmitComment:
            return "评论成功"
        case .Api_UserUpdate:
            return "修改成功"
        default:
            return nil
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}