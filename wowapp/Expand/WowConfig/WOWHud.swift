//
//  WOWHud.swift
//  Wow
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import SVProgressHUD

struct WOWHud {
    static func showLoading(){
//        SVProgressHUD.setDefaultStyle(.Custom)
//        SVProgressHUD.setDefaultMaskType(.Clear)
//        SVProgressHUD.setForegroundColor(UIColor.blackColor())
//        SVProgressHUD.setBackgroundColor(UIColor(white: 0.8, alpha: 0.8))
//        SVProgressHUD.show()
    
        dispatch_async(dispatch_get_main_queue()) {
            
            UIApplication.currentViewController()?.view.addSubview(LoadView.sharedInstance)
            
        }

    }
    
    static func dismiss(){
//        SVProgressHUD.popActivity()
        dispatch_async(dispatch_get_main_queue()) {
            
            LoadView.sharedInstance.dissMissView()
        }

    }
    
    static func showMsg(message:String?){
        configSVHud()
        let msg = message ?? "网络错误"
        SVProgressHUD.showInfoWithStatus(msg)
    }
    
    
    static func configSVHud(){
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setInfoImage(UIImage(named:"  "))
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
}
