//
//  WOWNetManager.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//


import SwiftyJSON
import ObjectMapper
import Moya

typealias LikeAction                = (_ isFavorite:Bool?) -> ()
typealias FailClosure               = (_ errorMsg:String?) -> ()
typealias SuccessClosure            = (_ result:AnyObject, _ code: String?) ->()

enum RequestCode:String{
    case FailError = "40000"
    case Success = "0"      //数据请求成功
    case Login = "10000"    //session过期或无效
    case ProductExpired = "40202"   //商品过期
    case ProductLimit = "40368" //商品限购
    case VersionNew = "50113" //当前为最新版本
}

//MARK:前后端约定的返回数据结构
class ReturnInfo: Mappable {
    var data:AnyObject? //若返回无数据，returnObject字段也得带上,可为空值
    var code: String?
    var message: String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data          <-    map["data"]
        code          <-    map["resCode"]
        message       <-    map["resMsg"]
    }
}


class WOWNetManager {
    static let sharedManager = WOWNetManager()
    fileprivate init(){}

    public static func endpointClosure(target: RequestApi) -> Endpoint<RequestApi> {
        
        let method = target.method
        let parameters = target.parameters
        let endpoint = Endpoint<RequestApi>(URL: target.baseURL.appendingPathComponent(target.path).absoluteString, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: method, parameters: parameters, parameterEncoding: target.encoding)
        return endpoint.endpointByAddingHTTPHeaderFields(target.headers())
    }
    
    let requestProvider = MoyaProvider<RequestApi>(endpointClosure: WOWNetManager.endpointClosure)

    
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
       
        print("request target 请求的URL：",target.path,"\n请求的参数： ",target.parameters ?? "","\n",WOWNetManager.endpointClosure(target: target).httpHeaderFields ?? ["":""])
    
       _ =  requestProvider.request(target) { (result) in
            //消失loading页面
//            DispatchQueue.main.async {
                WOWHud.dismiss()
//                LoadView.dissMissView()
//            }
        
            switch result{
                
                case let .success(response):
                    
                    _ = response.data
                    _ = response.statusCode

                    var jsonString      = ""
                    do {
                        
                        jsonString      = try! response.mapString() 
                    
                    } catch {
                        DLog("could not decode to string")
                    }

//                    let json_data = JSON(data: response.data,options: .allowFragments).string! 
                    let info = Mapper<ReturnInfo>().map(JSONString:jsonString)
                    
                    if (info as? String) != nil {
//                        DLog(str)
                    }
                    else {
                        // obj is not a String
                    }
                    
                     print("response resCode: ",info?.code,"\n resMsg: ",info?.message,"\n data: ",info?.data)
                    
                    //其实也只有登入能获得session token 而已了

                    if let session_token = info?.data?["sessionToken"]{
                        WOWUserManager.sessionToken = session_token as? String ?? WOWUserManager.sessionToken
                    }
                    
                    
                    if let code = info?.code{
                       
                        guard code == RequestCode.Success.rawValue else{
                            if code == RequestCode.Login.rawValue {
                                NotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
                                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                                WOWHud.showMsg("登录已过期，请重新登录")
                                WOWUserManager.exitLogin()
                                if ( UIApplication.currentViewController()?.className  == WOWLoginController.className){
                                    return
                                }else{
                                    UIApplication.currentViewController()?.toLoginVC(true)
                                failClosure("登录已过期，请重新登录")
                                    return
                                }
                            }
                            if code == RequestCode.FailError.rawValue {
                                failClosure(info?.message)
                                return
//                                WOWHud.showMsg("您未登录,请先登录")
//                                if ( UIApplication.currentViewController()?.className  == WOWLoginController.className){
//                                    return
//                                }else{
//                                    WOWUserManager.exitLogin()
//                                    UIApplication.currentViewController()?.toLoginVC(true)
//                                    failClosure("您未登录,请先登录")
//                                    return
//                                }
                            }
                            //产品过期或者失效
                            if code == RequestCode.ProductExpired.rawValue {
                                let res = info?.data ?? [] as AnyObject
                                WOWHud.showMsg(info?.message)
                                successClosure(res, info?.code)
                                
                                return
                            }
                            //产品限购
                            if code == RequestCode.ProductLimit.rawValue {
                                
                                WOWHud.showWarnMsg(info?.message)
                                return
                            }
                            
                            if code == RequestCode.VersionNew.rawValue {
                                return
                            }
                            
                            failClosure(info?.message)
                            
                            return
                        }
                    }else{
                        WOWHud.showMsg("网络错误")
                        failClosure("网络错误")
                        
                        return
                    }
                    
                    if let endMsg = target.endSuccessMsg{
                        if endMsg == ""{
//                            WOWHud.dismiss()
                           
                        }else{
                            WOWHud.showMsg(endMsg)
                        }
                    }
                    let res = info?.data ?? [] as AnyObject
                    successClosure(res, info?.code)
                case let .failure(error):
                    DLog(error)
                    WOWHud.showMsgNoNetWrok(message: "网络错误")
                   
                    failClosure("网络错误")
                    break
            }
        }
    }
}
