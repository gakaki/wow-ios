//
//  WOWCustormMessageView.swift
//  aaa
//
//  Created by 陈旭 on 2017/4/14.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class WOWCustormMessageView: UIView {
    
    static let sharedInstance = WOWCustormMessageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "FFD444")!
        self.frame =  CGRect.init(x: 0, y: 0, width: 8, height: 8)
        self.layer.cornerRadius = 4
        
    }
    static func show(){
        
        sharedInstance.alpha = 1.0
        
    }
    
    static func dissMissView()  {
        
//        UIView.animate(withDuration: 0.8, animations: {
        
            sharedInstance.alpha = 0.0
            
//        }, completion: { (true) in
//            
//        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
