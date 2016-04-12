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
    
    }
    
    static func showMsg(message:String?){
        configSVHud()
        let msg = message ?? ""
        SVProgressHUD.showInfoWithStatus(msg)
    }
    
    
    static func configSVHud(){
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setDefaultStyle(.Dark)
        SVProgressHUD.setInfoImage(UIImage(named:""))
    }
    
}
