//
//  UIView+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import UIKit

class ActionManager:NSObject{
    var actionDict:Dictionary<NSValue,()->()> = Dictionary()
    static let sharedManager = ActionManager()
    override fileprivate init(){}
}

public extension UIView{
//MARK:Layer
    func borderColor(_ borderWidth:CGFloat,borderColor:UIColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func borderRadius(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    
    func addCorner(_ roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
    
    /**
     * 默认为为grayColor
     * 默认透明度为0.5
     * 默认扩散范围为2
     * 默认阴影范围为size(1,1)
     - parameter color:
     */
    func shadow(_ color:UIColor = UIColor.gray,shadowOpacity:Float = 0.5,shadowRadius:CGFloat = 2,shadowOffset:CGSize = CGSize(width: 1, height: 1)) {
        self.layer.shadowColor = color.cgColor // 阴影的颜色
        self.layer.shadowOpacity = shadowOpacity // 阴影透明
        self.layer.shadowRadius = shadowRadius //// 阴影扩散的范围控制
        self.layer.shadowOffset = shadowOffset // 阴影的范围

    }
    
    
//MARK:ACTION
    func addAction(_ closure:@escaping ()->()){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.tapClick(_:)))
        self.addGestureRecognizer(tap)
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject: self)] = closure
    }
    
    func tapClick(_ tap:UITapGestureRecognizer){
        if let closure = ActionManager.sharedManager.actionDict[NSValue(nonretainedObject: tap.view)]{
            closure()
        }else{
            
        }
    }

//MARK:Frame
//    var width:CGFloat {
//        get {
//            return CGRectGetWidth(self.frame)
//        }
//        
//        set {
//            var frame = self.frame
//            frame.size.width = newValue
//            self.frame = frame
//        }
//    }
//    var height:CGFloat {
//        get {
//            return CGRectGetHeight(self.frame)
//        }
//        
//        set {
//            var frame = self.frame
//            frame.size.height = newValue
//            self.frame = frame
//        }
//    }
}
