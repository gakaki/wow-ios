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

    
        DispatchQueue.main.async {
            
            UIApplication.currentViewController()?.view.addSubview(LoadView.show())
            
            
        }

    }
     static func showLoadingSV(){
                SVProgressHUD.setDefaultStyle(.custom)
                SVProgressHUD.setDefaultMaskType(.clear)
                SVProgressHUD.setForegroundColor(UIColor.black)
                SVProgressHUD.setBackgroundColor(UIColor(white: 0.8, alpha: 0.8))
                SVProgressHUD.show()
        
    }
    static func dismiss(){
        SVProgressHUD.popActivity()
        DispatchQueue.main.async {
            
//            LoadView.sharedInstance.dissMissView()
            LoadView.dissMissView()
        }

    }
    
    static func showMsg(_ message:String?){
        DispatchQueue.main.async {
            LoadView.dissMissView()
//            LoadView.sharedInstance.dissMissView()
        }
        configSVHud()
        let msg = message ?? "网络错误"
        SVProgressHUD.showInfo(withStatus: msg)
    }
    
    
    static func configSVHud(){
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setInfoImage(UIImage(named:"  "))
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
}
