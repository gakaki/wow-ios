//
//  WowVCManager.swift
//  wowapp
//
//  Created by g on 16/7/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

//VCManager is collect the redirect code
import UIKit

extension  UIViewController {
    
    func toMainVC(){
        let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
        mainVC?.modalTransitionStyle = .FlipHorizontal
        AppDelegate.rootVC = mainVC
        self.presentViewController(mainVC!, animated: true, completion: nil)
    }
    func toLoginVC(){
//        let mainVC = UIStoryboard(name: "Login", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
//        mainVC?.modalTransitionStyle = .FlipHorizontal
//        AppDelegate.rootVC = mainVC
//        self.presentViewController(mainVC!, animated: true, completion: nil)
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWLoginController))
        self.pushVC( vc )
    }
    func toRegVC(){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController))
        self.pushVC( vc )
    }
    func toWeixinVC(){
        print("toWeixinVC")
    }

}
