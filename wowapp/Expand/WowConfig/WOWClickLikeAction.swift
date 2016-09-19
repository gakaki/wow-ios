//
//  WOWClickLikeAction.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/19.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWClickLikeAction {
    
    static let sharedAction = WOWClickLikeAction()
    private init(){}
    /**
     用户喜欢某个专题
     
     - parameter topicId:    专题ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
   static func requestLikeProject(topicId: Int,isFavorite:LikeAction){
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeProject(topicId: topicId), successClosure: {(result) in
           
                let favorite = JSON(result)["favorite"].bool ?? false
                
                isFavorite(isFavorite: favorite)
            
            
        }) { (errorMsg) in
            
            WOWHud.showMsg("网络错误")
            
        }

    }
    
    /**
     用户喜欢某个单品
     
     - parameter productId:  单品ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
     static func requestFavoriteProduct(productId: Int,isFavorite:LikeAction)  {
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:productId), successClosure: { (result) in
            
            
                let favorite = JSON(result)["favorite"].bool
                var params = [String: AnyObject]?()
                
                params = ["productId": productId, "favorite": favorite!]
                
                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params)
            
                isFavorite(isFavorite: favorite)
            
            
        }) { (errorMsg) in
            
             WOWHud.showMsg("网络错误")
        }
    }


}
