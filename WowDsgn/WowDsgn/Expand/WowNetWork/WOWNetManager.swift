//
//  WOWNetManager.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import SwiftyJSON
//import RxSwift
import ObjectMapper

typealias FailClosure = (errorMsg:String?) -> ()
typealias SuccessClosure = (result:AnyObject) ->()


enum RequestCode:Int{
    case FailError = 1000
    case Success = 1001
}


//MARK:前后端约定的返回数据结构
class ReturnInfo: Mappable {
    var data:AnyObject? //若返回无数据，returnObject字段也得带上,可为空值
    var code: Int!
    var message: String?
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        data          <-    map["data"]
        code          <-    map["errno"]
        message       <-    map["errmsg"]
    }
}


class WOWNetManager {
    static let sharedManager = WOWNetManager()
    private init(){}

    let requestProvider = MoyaProvider<RequestApi>()

    func requestWithTarget(target:RequestApi,successClosure:SuccessClosure,failClosure:FailClosure){
        WOWHud.showLoading()
        requestProvider.request(target) { (result) in
            switch result{
                case let .Success(response):
                    let info = Mapper<ReturnInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
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
                    guard let data = info?.data else{
                        failClosure(errorMsg:"网络错误")
                        WOWHud.showMsg("网络错误")
                        return
                    }
                    if let endMsg = target.endSuccessMsg{
                        WOWHud.showMsg(endMsg)
                    }else{
                        WOWHud.dismiss()
                    }
                    successClosure(result:data)
                case let .Failure(error):
                    DLog(error)
                    WOWHud.showMsg("网络错误")
                    break
            }
        }
    }
}
        /*
        requestProvider.request(target).subscribe { (event) -> Void in
            switch event{
                case .Next(let response):
                    let info = Mapper<ReturnInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
                    if let code = info?.code{
                        guard code == RequestCode.Success.rawValue else{
                            failClosure(errorMsg:info?.message)
                            WOWHud.showMsg(info?.message)
                            return
                        }
                    }else{
                        failClosure(errorMsg:"请求失败")
                        WOWHud.showMsg("请求失败")
                        return
                    }
                    guard let data = info?.data else{
                        failClosure(errorMsg:"请求失败")
                        WOWHud.showMsg("请求失败")
                        return
                    }
                    WOWHud.dismiss()
                    successClosure(result:data)
            case .Error(let error):
                    DLog(error)
                    failClosure(errorMsg:"网络错误")
                    WOWHud.showMsg("网络错误")
                default:
                    break
            }
        }.addDisposableTo(disposeBag)
    }*/
