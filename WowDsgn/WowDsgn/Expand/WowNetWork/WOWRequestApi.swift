//
//  WOWRequestApi.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public enum RequestApi{
    static var HostUrl:String! = "http://testapi.cddtwx.cn/api/AppConfig/GetAppConfig"
    
    case Weather
}


extension RequestApi:TargetType{
    public var baseURL:NSURL{
        return NSURL(string: RequestApi.HostUrl)!
    }
    
    public var path:String{
        switch self{
        case .Weather:
            return ""
        }
    }
    
    public var method:Moya.Method{
        switch self{
        case .Weather:
            return .POST
        }
    }
    
    public var parameters:[String: AnyObject]?{
        switch self{
        case .Weather:
            return nil
        }
    }
    
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}