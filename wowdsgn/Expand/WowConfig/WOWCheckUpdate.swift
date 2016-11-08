//
//  WOWCheckUpdate.swift
//  CheckUpdate
//
//  Created by 陈旭 on 2016/11/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
typealias CheckVersion = (_ CheckVersionResult:Bool?) ->()
class WOWCheckUpdate {
    
    open var isUpdateVersion :CheckVersion!
    
    static let urlItunes = "http://itunes.apple.com/cn/lookup?id=1110300308"
    static let sharedCheck = WOWCheckUpdate()
    static var currentAppStoreDevice = ""
    init(){}
    static func checkUpdateWithDevice(isUpdateTag: @escaping CheckVersion){
        let url = NSURL(string: urlItunes)
        let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            var receiveStatusDic = [String: AnyObject]()
            if data != nil {
                var receiveDic = [String: AnyObject]()
                do {
                    receiveDic = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String : AnyObject]
                    if let arr = receiveDic["results"] as? NSArray{
                        if let dict = arr.firstObject as? NSDictionary {
                            if let version = dict["version"] as? String {
                                print("线上版本号：\(version)")
                                
                                currentAppStoreDevice = version
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                
                if (receiveDic["resultCount"]?.integerValue)! > 0 {
                    receiveStatusDic["status"] = "1" as AnyObject?
                    
                } else {
                    receiveStatusDic["status"] = "-1" as AnyObject?
                }
            } else {
                receiveStatusDic["status"] = "-1" as AnyObject?
            }
            
            let infoDictionary = Bundle.main.infoDictionary
            // app版本
            let app_Version = infoDictionary!["CFBundleShortVersionString"] as? String
            
            var appVersionArr = currentAppStoreDevice.components(separatedBy: ".")
            var currentVersionArr = app_Version!.components(separatedBy: ".")
            
            if appVersionArr.count == 2 {
                appVersionArr.append("0")
            }
            if currentVersionArr.count == 2 {
                currentVersionArr.append("0")
            }
            
            let appVersionNum = appVersionArr[0].toInt()! * 100 + appVersionArr[1].toInt()! * 10 + appVersionArr[2].toInt()! * 1
            
            let currentVersionNum = currentVersionArr[0].toInt()! * 100 + currentVersionArr[1].toInt()! * 10 + currentVersionArr[2].toInt()! * 1
            
            if currentVersionNum < appVersionNum {
                isUpdateTag(true)
            }else{
                isUpdateTag(false)
            }

        })
        task.resume()
        
    }
    
}

