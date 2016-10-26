//
//  WOWUploadManager.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/26.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import Qiniu
import Alamofire
import Hashids_Swift
import FCUUID
class WOWUploadManager {
    
    static let sharedManager = WOWUploadManager()
    init(){}
    // 上传头像
    static  func upload(_ image:UIImage,successClosure:@escaping SuccessClosure,failClosure:@escaping FailClosure){
        
        let image = image.fixOrientation()
        let data = UIImageJPEGRepresentation(image,0.5)

        let uploadOption            = QNUploadOption.init(
            mime: nil,
            progressHandler: { ( key, percent_f) in
                //                print(key,percent_f)
            },
            params: nil  ,
            checkCrc: false,
            cancellationSignal: nil
        )

         //          拼接唯一字符串
        let onlyStr = FCUUID.uuidForDevice() + (Date().timeIntervalSince1970 * 1000).toString
        let hashids                 = Hashids(salt:onlyStr)
       
        let qiniu_key               = "user/avatar/\(hashids.encode([1,2,3])!)"
        
//        let qiniu_token_url         = [BaseUrl,"/",URL_QINIU_TOKEN].joined(separator: "")
        
//        let json_str                = json_serialize( ["key": qiniu_key as AnyObject,"bucket": "wowdsgn" as AnyObject] )
//        let params_qiniu            = ["paramJson": json_str ]
        WOWNetManager.sharedManager.requestWithTarget(.api_qiniu_token(qiniuKey: qiniu_key, bucket: "wowdsgn"), successClosure: { (result, code) in
            
                let token       = JSON(result)["token"].string
                WOWHud.showLoadingSV()

                if let qm          = QNUploadManager(){
                   
                    qm.put(data, key: qiniu_key, token: token, complete: { (info, key, resp) in
                        
                        if (info?.error != nil) {
                            DLog(info?.error)
                            WOWHud.showMsg("头像修改失败")
                            
                            failClosure("错误")
                            
                        } else {
                            
                            print(resp,resp?["key"])
                            print(info,key,resp)
                            let key = resp?["key"]
                            let headImageUrl = "http://img.wowdsgn.com/\(key!)"
                            
                            // 保存用户URL
                            WOWUserManager.userHeadImageUrl = headImageUrl
                            
                            // 保存 照片数据到本地，为了处理图像，不闪。  －－
                            let imageData:NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                            
                            WOWUserManager.userPhotoData = imageData as Data
//                            successClosure(headImageUrl as AnyObject)
                            successClosure(headImageUrl as AnyObject, "")
                        }

                    }, option: uploadOption)
            }

            
        }) {(errorMsg) in
        
        }
        //TODO
//        Alamofire.request(qiniu_token_url,method:.post, parameters: params_qiniu)
//            .response { request, response, data, error in
//                DLog(request)
//                DLog(response)
//                DLog(data)
//                DLog(error)
//                
//                if (( error ) != nil){
//                    WOWHud.dismiss()
//                }
//                
//                
//            }.responseJSON { (json) in
//                
//                let res   = JSON(json.result.value!)
//                let token = res["data"]["token"].string
//                
//                let qm    = QNUploadManager()
//                
//                qm.putData(
//                    data,
//                    key:   qiniu_key,
//                    token: token,
//                    complete: { ( info, key, resp) in
//                        
//                        WOWHud.dismiss()
//                        
//                        if (info.error != nil) {
//                            DLog(info.error)
//                            WOWHud.showMsg("头像修改失败")
//
//                             failClosure(errorMsg:"错误")
//                            
//                        } else {
//                            
//                            print(resp,resp["key"])
//                            print(info,key,resp)
//                            let key = resp["key"]
//
//                            
//                            // 保存用户URL
//                            WOWUserManager.userHeadImageUrl = headImageUrl
//
//                            // 保存 照片数据到本地，为了处理图像，不闪。  －－
//                            let imageData:NSData = NSKeyedArchiver.archivedDataWithRootObject(image)
//
//                            WOWUserManager.userPhotoData = imageData
//                            
//                            successClosure(result:headImageUrl)
//                        
//                        }
//                        
//                        
//                    },
//                    option: uploadOption
//                )
//        }
//      
    }

}
