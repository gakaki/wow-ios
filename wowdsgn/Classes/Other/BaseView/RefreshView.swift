//
//  RefreshView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class RefreshView:UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.addSubview(self.backView)
        self.addSubview(self.gifImage)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView:UIView = {
        
        let blackView = UIView()
        blackView.frame = CGRect(x: 0,y: 0,width: 80.w,height: 80.h)
        blackView.center = CGPoint(x: MGScreenWidth/2, y: MGScreenHeight/2 - 64)
//        blackView.backgroundColor = UIColor.whiteColor()
        blackView.backgroundColor = UIColor(hexString: "f5f5f5")
        
        blackView.layer.shadowColor = UIColor.black.cgColor
        
        blackView.layer.shadowOffset = CGSize(width: 0,height: 2)// 阴影偏移量
        blackView.layer.shadowOpacity = 0.05//阴影透明度，默认0
        blackView.layer.shadowRadius = 2//阴影半径，默认3
        blackView.layer.cornerRadius = 8.0
        blackView.alpha = 0.9
        
        return blackView
        
    }()
    
    lazy var gifImage:UIImageView = {

        let image = YYImage(named: "loadRefresh")
        let imageView = YYAnimatedImageView(image: image)

        imageView.frame = CGRect(x: 0,y: 0,width: 50.w,height: 50.h)
        imageView.center = CGPoint(x: MGScreenWidth/2, y: MGScreenHeight/2 - 64)
//        imageView.alpha = 0.8
        return imageView
    }()
    
   }
class LoadView {

    static let sharedInstance: RefreshView = {
        let instance = RefreshView()
        instance.frame = UIScreen.main.bounds
       
        return instance
    }()
    
    static func show() -> UIView{
        sharedInstance.alpha = 1.0
        return sharedInstance
    }
    
    static func dissMissView()  {

        UIView.animate(withDuration: 0.8, animations: {
            
            sharedInstance.alpha = 0.0
            
            }, completion: { (true) in
                
                sharedInstance.removeFromSuperview()
        }) 
    }
}


