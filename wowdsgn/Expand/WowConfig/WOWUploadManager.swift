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
typealias HeadImgURL               = (_ url:String?) -> ()
typealias PushImgURLs              = (_ result:[String]) ->()
class WOWUploadManager {
    
   static let globalQueue = DispatchQueue.global()
   static let group = DispatchGroup()
    
    static let sharedManager = WOWUploadManager()
    init(){}
    
   static func onlyStr() -> String  {
        //          拼接唯一字符串
        let onlyStr = FCUUID.uuidForDevice() + (Date().timeIntervalSince1970 * 1000).toString
        let hashids                 = Hashids(salt:onlyStr)
        return hashids.encode([1,2,3])!
        
    }

    // 上传头像
    static  func uploadPhoto(_ image:UIImage,successClosure:@escaping HeadImgURL,failClosure:@escaping FailClosure){
        //          拼接唯一字符串

        let qiniu_key               = "user/avatar/\(onlyStr())"

        
        PushImage(image, imagePath: qiniu_key, successClosure: { (url) in
            // 保存用户URL
            if let url = url {
                WOWUserManager.userHeadImageUrl = url
            }else{
                print("上传头像格式错误")
            }
            
            // 保存 照片数据到本地，为了处理图像，不闪。  －－
            let imageData:NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
            
            WOWUserManager.userPhotoData = imageData as Data
            
            successClosure(url)

        }) { (errorMsg) in
            
            WOWHud.showMsg("上传图片失败")
            
        }
        
    }

    // 发布评论 上传图片 GCD 分组
    static func pushCommentPhotos(_ images:[imageInfo],successClosure:@escaping PushImgURLs){
        var urlArray = [String]()
        
        for image in images.enumerated(){
            group.enter()// 标记
            
            DispatchQueue.global().async(group: group) {
                
                let qiniu_key               = "product-review/\(onlyStr() + (image.element.imageName ?? ""))"

                PushImage(image.element.image, imagePath: qiniu_key, successClosure: { (url) in
                    
                    urlArray.append(url!)
                    
                    group.leave()// 完成
                    
                }, failClosure: { (errorMsg) in
                    
                    WOWHud.showMsg("上传图片失败")
                    
                })
                
                
            }
        }
        // 统一回调通知完成
        group.notify(queue: globalQueue) {
            
            successClosure(urlArray)
            
        }
        
    }
    

    // 上传图片
    static  func PushImage(_ image:UIImage,imagePath:String!,successClosure:@escaping HeadImgURL,failClosure:@escaping FailClosure){
        
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
        WOWNetManager.sharedManager.requestWithTarget(.api_qiniu_token(qiniuKey: imagePath, bucket: "wowdsgn"), successClosure: { (result, code) in
            
                let token       = JSON(result)["token"].string
                WOWHud.showLoadingSV()

                if let qm          = QNUploadManager(){
                   
                    qm.put(data, key: imagePath, token: token, complete: { (info, key, resp) in
                         WOWHud.dismiss()
                        if (info?.error != nil) {
//                            DLog(info?.error)
                            
                            failClosure("错误")
                            
                        } else {
                            
//                            print(resp,resp?["key"])
//                            print(info,key,resp)
                            let key = resp?["key"]
                            let headImageUrl = "https://img.wowdsgn.com/\(key!)"
                            
                           
                            successClosure(headImageUrl)

                        }

                    }, option: uploadOption)
            }

            
        }) {(errorMsg) in
            failClosure("错误")
        }
    }
    
}
