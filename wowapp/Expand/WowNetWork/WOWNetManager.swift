//
//  WOWNetManager.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

typealias FailClosure             = (errorMsg:String?) -> ()
typealias SuccessClosure          = (result:AnyObject) ->()


enum RequestCode:String{
    case FailError = "40000"
    case Success = "0"      //数据请求成功
}


//MARK:前后端约定的返回数据结构
class ReturnInfo: Mappable {
    var data:AnyObject? //若返回无数据，returnObject字段也得带上,可为空值
    var code: String?
    var message: String?
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        data          <-    map["data"]
        code          <-    map["resCode"]
        message       <-    map["resMsg"]
    }
}


class WOWNetManager {
    static let sharedManager = WOWNetManager()
    private init(){}

    let requestProvider = MoyaProvider<RequestApi>()

    func requestWithTarget(target:RequestApi,successClosure:SuccessClosure,failClosure:FailClosure){
        WOWHud.showLoading()
        print("request target 请求的URL：",target.path,"\n请求的参数： ",target.parameters)
        requestProvider.request(target) { (result) in
       
            switch result{
                case let .Success(response):
                    let info = Mapper<ReturnInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
                    
                     print("response resCode: ",info?.code,"\n resMsg: ",info?.message,"\n data: ",info?.data)
                    
                    //其实也只有登入能获得session token 而已了
                    if let session_token = info?.data?["sessionToken"] {
                        WOWUserManager.sessionToken = session_token as! String
                    }
                    
                    
                    if let code = info?.code{
                        guard code == RequestCode.Success.rawValue else{
                            failClosure(errorMsg:info?.message)
                            WOWHud.showMsg(info?.message)
                            return
                        }
                    }else{
                        failClosure(errorMsg:"网络错误")
                        WOWHud.showMsg("网络错误")
                        return
                    }
                    //逻辑变化了 返回0为成功
//                    guard let data = info?.data else{
//                        failClosure(errorMsg:"网络错误")
//                        WOWHud.showMsg("网络错误")
//                        return
//                    }
                    
                    if let endMsg = target.endSuccessMsg{
                        if endMsg == ""{
                            
                        }else{
                            WOWHud.showMsg(endMsg)
                        }
                    }else{
                        WOWHud.dismiss()
                    }
                    successClosure(result:info?.data ?? "")
                case let .Failure(error):
                    DLog(error)
                    WOWHud.showMsg("网络错误")
                    failClosure(errorMsg:"网络错误")
                    break
            }
        }
    }
}