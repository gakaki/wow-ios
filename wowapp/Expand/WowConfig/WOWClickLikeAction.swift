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
    static var params = [String: AnyObject]()
    private init(){}
    
    static  func likeAnimate(view: UIView, btn: UIButton) {
        
        let imgView = UIImageView(frame: btn.frame)
        imgView.contentMode = .scaleAspectFit
        imgView.image = btn.image(for: .selected)
        view.addSubview(imgView)
        UIView.animate(withDuration: 0.6, animations: {
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
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeProject(topicId: topicId), successClosure: {(result) in
            
            let favorite = JSON(result)["favorite"].bool ?? false
            if favorite == true {
                likeAnimate(view: view, btn: btn)
            }
            isFavorite(favorite)
            
            
        }) { (errorMsg) in
            
            WOWHud.showMsg("网络错误")
            
        }
        
    }
    
    /**
     用户喜欢某个单品
     
     - parameter productId:  单品ID
     - parameter isFavorite: 请求结果，是否喜欢
     */
    static func requestFavoriteProduct(productId: Int,view: UIView, btn: UIButton,isFavorite:@escaping LikeAction)  {
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteProduct(productId:productId), successClosure: {(result) in
            
            
            let favorite = JSON(result)["favorite"].bool
            
            params = ["productId": productId as AnyObject, "favorite": favorite! as AnyObject]
            if favorite == true {
                btn.isSelected  = favorite!
                likeAnimate(view: view, btn: btn)
                
            }else{
                NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params as AnyObject?)
            }
            
            isFavorite(favorite)
            
        }) { (errorMsg) in
            
            WOWHud.showMsg("网络错误")
        }
    }
    
    
}
