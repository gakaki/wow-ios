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
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setForegroundColor(UIColor.blackColor())
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.8, alpha: 0.8))
        SVProgressHUD.show()
    }
    
    static func dismiss(){
        SVProgressHUD.popActivity()
    }
    
    static func showMsg(message:String?){
        configSVHud()
        let msg = message ?? "请求失败"
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
