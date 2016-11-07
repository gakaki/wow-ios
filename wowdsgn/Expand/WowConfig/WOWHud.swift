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

            LoadView.dissMissView()
        }

    }
    // 接口请求成功，返回code码错误
    static func showMsg(_ message:String?){
//        DispatchQueue.main.async {
//            
////            WOWHud.dismiss()
//
//        }
        configSVHud()
        let msg = message ?? "网络错误"
        SVProgressHUD.showInfo(withStatus: msg)
    }
    // 接口请求不成功
    static func showMsgNoNetWrok(message:String?){
//        DispatchQueue.main.async {
////            WOWHud.dismiss()
//        }
        configSVHud()
        let msg = message ?? "网络错误"
        SVProgressHUD.showInfo(withStatus: msg)
        
        WOWNetWorkType.netWorkType { (NotReachable) in
            
            if NotReachable == false {
                self.noNetView.refreshDataBlock = {
                    noNetView.removeNoDataAndNetworkView()
                    (UIApplication.currentViewController() as? WOWBaseViewController)?.request()
                }
                self.noNetView.showView(view: (UIApplication.currentViewController()?.view)!)
            }
        }
        
    }
    
    static var noNetView:WOWNoNetView = {
        let view = WOWNoNetView()
        view.frame = UIScreen.main.bounds
        return view
    }()
    

    
    static func configSVHud(){
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setInfoImage(UIImage(named:""))
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
}
