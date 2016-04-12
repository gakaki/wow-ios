//
//  WOWNetManager.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import ObjectMapper

typealias FailClosure = (errorMsg:String?) -> ()
typealias SuccessClosure = (result:AnyObject) ->()

enum RequestCode:Int{
    case FailError = 1001
    case Success = 1000
}


//MARK:前后端约定的返回数据结构
class ReturnInfo: Mappable {
    var returnObject:AnyObject? //若返回无数据，returnObject字段也得带上,可为空值
    var code: Int!
    var message: String?
    required init?(_ map: Map) {
    }
    func mapping(map: Map) {
        returnObject  <-    map["returnObject"]
        code          <-    map["code"]
        message       <-    map["message"]
    }
}


class NetManager {
    static let sharedManager = NetManager()
    private init(){}

    let requestProvider = RxMoyaProvider<RequestApi>()
    let disposeBag = DisposeBag()
    func requestWithTarget(target:RequestApi,successClosure:SuccessClosure,failClosure:FailClosure){
        requestProvider.request(target).subscribe { (event) -> Void in
            switch event{
                case .Next(let response):
                    DLog(JSON(data: response.data))
                    let info = Mapper<ReturnInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
                    if let code = info?.code{
                        guard code == RequestCode.Success.rawValue else{
                            failClosure(errorMsg:info?.message)
                            return
                        }
                    
                    }else{
                        failClosure(errorMsg:"加载失败")
                        return
                    }
                    guard let data = info?.returnObject else{
                        failClosure(errorMsg:"加载失败")
                        return
                    }
                    successClosure(result:data)
                case .Error(let error):
                    DLog(error)
                    failClosure(errorMsg:"网络错误")
                default:
                    break
            }
        }.addDisposableTo(disposeBag)
    }
}
