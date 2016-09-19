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

    
   static  func requestLikeProject(topicId: Int,isFavorite:LikeAction){
        //用户喜欢某个专题
        
        WOWHud.showLoadingSV()
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeProject(topicId: topicId), successClosure: {(result) in
           
                let favorite = JSON(result)["favorite"].bool ?? false
                
                isFavorite(isFavorite: favorite)
            
            
        }) { (errorMsg) in
            
            return false
            
        }
        
    }

}
