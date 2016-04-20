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
    
    
    
    case Api_Login(String,String)
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
            
            
        case .Api_Login:
            return URL_login
        }
    }
    
    public var method:Moya.Method{
        return .POST
    }
    
    public var parameters:[String: AnyObject]?{
        switch self{
        case let .Api_Sence(_, value):
            return ["pageIndex":String(value)]
        case let .Api_Login(account,password):
            return ["account":account,"password":password]
        default:
            return nil
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}