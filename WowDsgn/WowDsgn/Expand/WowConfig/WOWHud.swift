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
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.show()
    }
    
    static func dismiss(){
        SVProgressHUD.dismiss()
    }
    
    static func showMsg(message:String?){
        configSVHud()
        let msg = message ?? "加载失败"
        SVProgressHUD.showInfoWithStatus(msg)
    }
    
    
    static func configSVHud(){
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setDefaultStyle(.Dark)
        SVProgressHUD.setInfoImage(UIImage(named:"  "))
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
}
