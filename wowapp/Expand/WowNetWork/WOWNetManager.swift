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
typealias LikeAction                = (_ isFavorite:Bool?) -> ()
typealias FailClosure               = (_ errorMsg:String?) -> ()
typealias SuccessClosure            = (_ result:AnyObject) ->()

enum RequestCode:String{
    case FailError = "40000"
    case Success = "0"      //数据请求成功
    case Login = "10000"    //session过期或无效
}

//MARK:前后端约定的返回数据结构
class ReturnInfo: Mappable {
    var data:AnyObject? //若返回无数据，returnObject字段也得带上,可为空值
    var code: String?
    var message: String?
    required init?(_ map: Map) {
    }
    
    func mapping(_ map: Map) {
        data          <-    map["data"]
        code          <-    map["resCode"]
        message       <-    map["resMsg"]
    }
}


class WOWNetManager {
    static let sharedManager = WOWNetManager()
    fileprivate init(){}

    let requestProvider = MoyaProvider<RequestApi>()

    
    func getPresentedController() -> UIViewController? {
        let appRootVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        let topVC: UIViewController     = appRootVC
        let presentedVC                 = topVC.presentedViewController
        
        return presentedVC
    }
   

    func requestWithTarget(
        _ target:RequestApi,
        successClosure:@escaping SuccessClosure,
        failClosure:@escaping FailClosure
    ){
       
//        DLog("request target 请求的URL：",target.path,"\n请求的参数： ",target.parameters)
        
        requestProvider.request(target) { (result) in
       
            switch result{
                case let .Success(response):
                    let info = Mapper<ReturnInfo>().map(JSON(data: response.data,options: .AllowFragments).object)
                    
                    
                    if let str = info as? String {
//                        DLog(str)
                    }
                    else {
                        // obj is not a String
                    }
                    
//                     DLog("response resCode: ",info?.code,"\n resMsg: ",info?.message,"\n data: ",info?.data)
                    
                    //其实也只有登入能获得session token 而已了

                    if let session_token = info?.data?["sessionToken"]{
                        WOWUserManager.sessionToken = session_token as? String ?? WOWUserManager.sessionToken
                    }
                    
                    
                    if let code = info?.code{
                       
                        guard code == RequestCode.Success.rawValue else{
                            if code == RequestCode.Login.rawValue {
                                NSNotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
                                NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                                WOWHud.showMsg("登录已过期，请重新登录")
                                WOWUserManager.exitLogin()
                                if ( UIApplication.currentViewController()?.className  == WOWLoginController.className){
                                    return
                                }else{
                                    UIApplication.currentViewController()?.toLoginVC(true)
                                failClosure(errorMsg:info?.message)
                                    return
                                }
                            }
                            if code == RequestCode.FailError.rawValue {
                                
                                WOWHud.showMsg("您未登录,请先登录")
                                if ( UIApplication.currentViewController()?.className  == WOWLoginController.className){
                                    return
                                }else{
                                    WOWUserManager.exitLogin()
                                    UIApplication.currentViewController()?.toLoginVC(true)
                                    failClosure(errorMsg:info?.message)
                                    return
                                }
                            }
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
                            WOWHud.dismiss()
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
