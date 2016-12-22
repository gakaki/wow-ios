//
//  WOWCommentManage.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/12/22.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWCommentManage: NSObject {

}
class imageInfo: NSObject {
    var image       : UIImage! // image对象
    var imageName   : String! // image名称，保证路径唯一
}

// 记录用户选择的图片的数据
class UserPhotoManage: NSObject {
    
    var imageArr            = [UIImage]() // 所选择的数组
    var userIndexSection    : Int?// 对应商品的下标
    var assetsArr           = [AnyObject]()// 所选择的photo的Asset
    var UserCommentDic      : [String:AnyObject]?//
}
// 记录用户评论的操作
class UserCommentManage :NSObject{
    
    var saleOrderItemId         : Int? // 对应产品 Id
    var comments                : String = "" // 输入的评论内容
    var commentImgs             = [String]()// 选择的照片Url的数组
    var commentsLength          : Int = 0 //评论内容的个数 有表情内容会影响string的length 不准，所以记录textView上面的length
    
}
extension UserCommentManage {
    
    func cheackCommentLength() -> Bool {
        
        
        if !(self.comments == "" && self.commentImgs.count == 0){
           
            if self.commentImgs.count > 0 {// 如果选择了照片，而没用输入内容，则提示他输入内容
                if self.commentsLength == 0 {
                    
                    WOWHud.showMsg("请输入的评论内容")
                    
                    return false
                }
            }
            if self.commentsLength < 3 && self.commentsLength > 0{// 如果输入了内容，而输入的内容小于三个字，则提示他输入更多内容
                
                WOWHud.showMsg("请您输入更多的评论内容")
                return false
                
            }
            if self.commentsLength > 140 {
                
                WOWHud.showMsg("评论的最大字数为140字，请您删减")
                
                return false
                
            }


        }
        
        return true
        
    }
}

/// 存储图片名字和图片本身
struct WOWGetImageInfo {
    
   /// 存储图片名字和图片本身
     static func printAssetsName(assets: [AnyObject] ,images: [UIImage]) -> [imageInfo]{
        var fileName: String = ""
        var imageInfoArray = [imageInfo]()
        for asset in assets.enumerated() {
            if (asset.element is PHAsset) {
                let phAsset = (asset.element as! PHAsset)
                fileName = (phAsset.value(forKey: "filename") as! String)
                let info = imageInfo()
                info.imageName = fileName
                info.image = images[asset.offset]
                imageInfoArray.append(info)
            }
            
        }
        return imageInfoArray
    }
   
}
