//
//  RefreshView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
class RefreshView:UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    override func drawRect(rect: CGRect) {
        self.addSubview(self.backView)
        self.gifImage.center = self.center
        self.addSubview(self.gifImage)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView:UIView = {
        
        let blackView = UIView()
        blackView.frame = UIScreen.mainScreen().bounds
        blackView.backgroundColor = UIColor.init(hexString: "f5f5f5")
        
        blackView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                
                strongSelf.dissMissView()
                
            }
        }
        
        return blackView
        
    }()

    
    lazy var gifImage:UIImageView = {

        let image = YYImage(named: "loadRefresh")
        let imageView = YYAnimatedImageView(image: image)

        imageView.frame = CGRectMake(0,0,50.w,50.h)
        imageView.center = self.center
        
        return imageView
    }()
    
    func dissMissView()  {
        self.removeFromSuperview()
    }
    
}
class LoadView {

    static let sharedInstance: RefreshView = {
        let instance = RefreshView()
        
        instance.frame = UIScreen.mainScreen().bounds
       
        return instance
    }()
    
}


struct WOWHudRefresh {
    
    
    static  func showInView(view:UIView) {
        
        dispatch_async(dispatch_get_main_queue()) {

            view.addSubview(LoadView.sharedInstance)
            
        }
        
    }
    
    static func dismiss(){
        dispatch_async(dispatch_get_main_queue()) {

            LoadView.sharedInstance.dissMissView()
        }

    }
    
}


