//
//  WOWPopMan.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum WOWPopManDirection {
    case Left
    case Top
    case Bottom
    case Right
    case Center
}

let screenHeight = [UIScreen.mainScreen().bounds.size.height]
let screenWidth = [UIScreen.mainScreen().bounds.size.width]

struct WOWPopManSetting {
   static var dimsBackgroundDuringPresentation:Bool = true
   static var dimsBackgroundColor:UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha:0.4)
   static var showDuration:CGFloat = 0.3
   static var showDirecton:WOWPopManDirection = .Bottom
   static var customerView:UIView? = nil
}


typealias dismissBlock = ([String:String])->()

/*
class WOWPopMan: NSObject {
    static var block:dismissBlock?
    
    static var backView:UIView = UIView()
    
    static func show(block:dismissBlock?){
        self.block = block
        backView.backgroundColor = WOWPopManSetting.dimsBackgroundColor
        backView.bounds = UIScreen.mainScreen().bounds
        backView.hidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backView.addGestureRecognizer(tap)
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let appdelegate = delegate {
            appdelegate.window?.addSubview(backView)
            appdelegate.window?.bringSubviewToFront(backView)
        }
        
        if let customerView = WOWPopManSetting.customerView {
            switch WOWPopManSetting.showDirecton {
            case .Bottom:
                
            default:
                break
            }
            backView.addSubview(customerView)
            customerView.hidden = true
        }
        
        
    }
    
    static func dismiss(){
        
    }
}
*/