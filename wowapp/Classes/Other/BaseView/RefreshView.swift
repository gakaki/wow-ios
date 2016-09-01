//
//  RefreshView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class RefreshView:UIView {

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    lazy var backClear:UIView! = {
//        let v = UIView(frame:CGRectMake(0, self.h, self.w,self.popWindow.h))
//        v.backgroundColor = UIColor.clearColor()
//        return v
//    }()
    
//    lazy var shareView:RefreshView = {
//       let shareView = RefreshView()
//        shareView.frame = UIScreen.mainScreen().bounds
//        shareView.backgroundColor = UIColor.whiteColor()
//        return shareView
//    }()
    
    private func setUP(){
//        self.backgroundColor = MaskColor
//        self.alpha = 0
//        self.addTapGesture {[weak self](tap) in
//            if let strongSelf = self{
//                strongSelf.dismiss()
//            }
//        }
    }
    override func drawRect(rect: CGRect) {
        self.gifImage.center = self.center
        self.addSubview(self.gifImage)
    }
//    lazy var popWindow:UIWindow = {
//        let w = UIApplication.sharedApplication().delegate as! AppDelegate
//        return w.window!
//    }()
    
    lazy var gifImage:UIImageView = {

        let image = YYImage(named: "intro")
        let imageView = YYAnimatedImageView(image: image)
        imageView.frame = UIScreen.mainScreen().bounds

        return imageView
    }()
    
//    func showInView(view:UIView) {
//        dispatch_async(dispatch_get_main_queue()) { 
//            view.addSubview(self.shareView)
//            self.setNeedsDisplay()
//        }
//
//    }
    
//   internal func dismiss() {
//
//        dispatch_async(dispatch_get_main_queue()) {
//            self.shareView.removeFromSuperview()
//            self.setNeedsDisplay()
//        }
//
//        
//    }
  
}

struct WOWHudRefresh {
    
    
    static  func showInView(view:UIView) {
        dispatch_async(dispatch_get_main_queue()) {

            let shareView = UIView()
            shareView.frame = UIScreen.mainScreen().bounds
            shareView.backgroundColor = UIColor.clearColor()

            let blackView = UIView()
            blackView.frame = shareView.frame
            blackView.backgroundColor = UIColor.init(hexString: "f5f5f5")
            
                let image = YYImage(named: "loadRefresh")
                let imageView = YYAnimatedImageView(image: image)
                imageView.frame = CGRectMake(0,0,65,65)
                imageView.center = view.center
                imageView.centerY = view.centerY - 50
                

            shareView.addSubview(blackView)
            shareView.addSubview(imageView)
            
            view.addSubview(shareView)
            

        }
        
    }
    
    static func dismiss(){
        
    }
    
    static func showMsg(message:String?){
        configSVHud()
       
    }
    
    
    static func configSVHud(){
       
    }

    
}


