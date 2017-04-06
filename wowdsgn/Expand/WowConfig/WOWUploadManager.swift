//
//  WOWUploadManager.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/26.
//

import UIKit
import Qiniu
import Alamofire
import Hashids_Swift
import FCUUID
typealias HeadImgURL               = (_ url:String?) -> ()
typealias PushImgURLs              = (_ result:[String]) ->()

enum QiniuBucket:String {// 七牛的路径
    
    case UserPhoto          = "user/avatar/"
    case FeebdBack          = "user/feedback/"
    case UserShopComment    = "product-review/"
    case ShowWorksDetail    = "social/insta/"
}


class WOWUploadManager {
    
   static let globalQueue = DispatchQueue.global()
   static let group = DispatchGroup()
    
    static let sharedManager = WOWUploadManager()
    init(){}
    // 压缩图片到指定的体积
   static func imageCompressForWidth(sourceImage: UIImage, targetWidth defineWidth: CGFloat) -> UIImage {
        let imageSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = defineWidth
        let targetHeight: CGFloat = (targetWidth / width) * height
        UIGraphicsBeginImageContext(CGSize.init(width: targetWidth, height: targetHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? sourceImage
    }
    // 针对时间戳 进行哈希
   static func onlyStr() -> String  {
        //          拼接唯一字符串
        let onlyStr         = FCUUID.uuidForDevice() + (Date().timeIntervalSince1970 * 1000).toString
        let hashids         = Hashids(salt:onlyStr)
        return hashids.encode([1,2,3])!
        
    }
    // 针对 userId 进行 哈希
    static func hashidsUserIdStr() -> String {
        
        if WOWUserManager.userID.isEmpty {
            return onlyStr()
        }else{
            let hashids         = Hashids(salt:WOWUserManager.userID)
            return hashids.encode([1,2,3])!
           
        }
    
    }

    // 上传头像
    static  func uploadPhoto(_ image:UIImage,successClosure:@escaping HeadImgURL,failClosure:@escaping FailClosure){
         // 压缩图片
//        let photoImage = imageCompressForWidth(sourceImage: image, targetWidth: 200)
         //          拼接唯一字符串
        let qiniu_key  = QiniuBucket.UserPhoto.rawValue + hashidsUserIdStr()
        
        PushImage(image, imagePath: qiniu_key, successClosure: { (url) in
            // 保存用户URL
            if let url = url {
                let serverUrl = url + "?v=" + onlyStr() // 由于七牛云服务器的图片缓存问题， 所以在传给后台的时候， 要 拼上 ?v= XXX 这样的格式，确保从七牛读取图片时，拿到的最新的图片data ,同时本地也是如此
                WOWUserManager.userHeadImageUrl = serverUrl
                // 保存 照片数据到本地，为了处理图像，不闪。  －－
                let imageData:NSData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
                
                WOWUserManager.userPhotoData = imageData as Data
                
                successClosure(serverUrl)

            }else{
                print("上传头像格式错误")
            }
            
           
        }) { (errorMsg) in
            
            WOWHud.showMsg("上传图片失败")
            
        }
        
    }
    // 上传分享的图片
    static  func uploadShareImg(_ image:UIImage,successClosure:@escaping HeadImgURL,failClosure:@escaping FailClosure){

        // 拼接唯一字符串
        let qiniu_key  = QiniuBucket.ShowWorksDetail.rawValue + hashidsUserIdStr() + onlyStr() + "_2dimension_" + String(describing: NSDecimalNumber(value: Int(image.size.width))) + "x" + String(describing: NSDecimalNumber(value: Int(image.size.height)))
        
        PushImage(image, imagePath: qiniu_key, successClosure: { (url) in
            // 保存用户URL
            if let url = url {

                successClosure(url)
                
            }else{
                
                print("上传头像格式错误")
                
            }
            
            
        }) { (errorMsg) in
            
            WOWHud.showMsg("上传图片失败")
            
        }
        
    }
    

    // 发布评论 上传图片 GCD 分组  pushQiniuPath ： 上传至七牛服务器的 路径， 默认为 商品评论的路径，
    static func pushCommentPhotos(_ images:[imageInfo],pushQiNiuPath:QiniuBucket = .UserShopComment,successClosure:@escaping PushImgURLs){
        var urlArray = [String]()
        
        for image in images.enumerated(){
            group.enter()// 标记
            
            DispatchQueue.global().async(group: group) {
                
                let qiniu_key               = pushQiNiuPath.rawValue + (onlyStr() + (image.element.imageName ?? ""))

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
