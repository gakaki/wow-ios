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
    static var params :[String:AnyObject]?
    private init(){}
    
    static  func likeAnimate(view: UIView, btn: UIButton) {
        
        let imgView = UIImageView(frame: btn.frame)
        imgView.contentMode = .scaleAspectFit
        imgView.image = btn.image(for: .selected)
        view.addSubview(imgView)
        UIView.animate(withDuration: 0.5, animations: {
            imgView.transform = CGAffineTransform(scaleX: 2, y: 2)
            imgView.alpha = 0
        }) { (finished) in
            imgView.removeFromSuperview()
            // 在动画结束之后，发送刷新数据源的通知，因为直接reloadtableView，动画不会出现
            NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params as AnyObject?)
            
        }
        
    }
    
    /**
     用户喜欢某个专题
     
     - parameter topicId:    专题ID
     - parameter view:       点赞动画加在哪个View上
     - parameter btn:        那个按钮需要点赞动画
     - parameter isFavorite: 请求结果，是否喜欢
     */
    
    static func requestLikeProject(topicId: Int,view: UIView, btn: UIButton,isFavorite: @escaping LikeAction){
        WOWHud.showLoadingSV()
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeProject(topicId: topicId), successClosure: {(result, code) in
            
            let favorite = JSON(result)["favorite"].bool ?? false
            if favorite == true {
                likeAnimate(view: view, btn: btn)
            }
            isFavorite(favorite)
            WOWHud.dismiss()
            
        }) { (errorMsg) in
            WOWHud.dismiss()
            WOWHud.showMsg("网络错误")
            
        }
        
    }
    
    /**
     用户喜欢某个单品
     
     - parameter productId:  单品ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
    static func requestFavoriteProduct(productId: Int,view: UIView, btn: UIButton,isFavorite:@escaping LikeAction)  {
         WOWHud.showLoadingSV()
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteProduct(productId:productId), successClosure: {(result, code) in
            
            
            let favorite = JSON(result)["favorite"].bool
            
            params = ["productId": productId as AnyObject, "favorite": favorite! as AnyObject]
            if favorite == true {
                btn.isSelected  = favorite!
                likeAnimate(view: view, btn: btn)
                
            }else{
                NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params as AnyObject?)
            }
            
            isFavorite(favorite)
            WOWHud.dismiss()
        }) { (errorMsg) in
            WOWHud.dismiss()
            WOWHud.showMsg("网络错误")
        }
    }
    
    /**
     用户喜欢某个品牌
     
     - parameter productId:  品牌ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
    static func requestFavoriteBrand(brandId: Int,view: UIView, btn: UIButton,isFavorite: @escaping LikeAction){
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        params = nil
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteBrand(brandId: brandId), successClosure: { (result, code) in
                let favorite = JSON(result)["favorite"].bool
                
                if favorite == true {
//                    btn.isSelected  = favorite!
                    likeAnimate(view: view, btn: btn)
                    
                }else{
                    btn.isSelected  = favorite!
                    NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object:nil)
                }
                
                isFavorite(favorite)

        }) { (errorMsg) in
            
             WOWHud.showMsg("网络错误")
        }
        
    }
    /**
     用户喜欢某个设计师
     
     - parameter productId:  设计师ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
    static func requestFavoriteDesigner(designerId: Int,view: UIView, btn: UIButton,isFavorite: @escaping LikeAction){
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        params = nil
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteDesigner(designerId: designerId), successClosure: {(result, code) in
            let favorite = JSON(result)["favorite"].bool
            
            if favorite == true {
//                btn.isSelected  = favorite!
                likeAnimate(view: view, btn: btn)
                
            }else{
                btn.isSelected  = favorite!
                NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object:nil)
            }
            
            isFavorite(favorite)
            
        }) { (errorMsg) in
            
            WOWHud.showMsg("网络错误")
        }
    }
    
    /**
     用户喜欢某个评论
     
     - parameter commentId:    评论ID
     - parameter view:       点赞动画加在哪个View上
     - parameter btn:        那个按钮需要点赞动画
     - parameter isFavorite: 请求结果，是否喜欢
     */
    
    static func requestLikeComment(commentId: Int,view: UIView, btn: UIButton,isFavorite: @escaping LikeAction){
        WOWHud.showLoadingSV()
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteTopicComment(commentId: commentId), successClosure: {(result, code) in
            
            let favorite = JSON(result)["favorite"].bool ?? false
            if favorite == true {
                likeAnimate(view: view, btn: btn)
            }
            isFavorite(favorite)
            WOWHud.dismiss()
            
        }) { (errorMsg) in
            WOWHud.dismiss()
            WOWHud.showMsg("网络错误")
            
        }
        
    }
}

