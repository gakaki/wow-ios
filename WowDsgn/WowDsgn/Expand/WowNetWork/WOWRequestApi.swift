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
    
    case Api_ProductDetail(productid:String)
    
    case Api_UserUpdate(param:[String:String])
    
    case Api_Login(String,String)
    
    case Api_Register(account:String,password:String)
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
        case .Api_UserUpdate:
            return URL_UpdateInfo
        case .Api_Login:
            return URL_login
        case .Api_Register:
            return URL_Register
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
            return ["pageindex":pageindex,"cid":categoryID,"style":style,"sort":sort]
        case let .Api_ProductDetail(productid):
            return ["id":productid]
        case let .Api_UserUpdate(param):
            return param
        default:
            return nil
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}