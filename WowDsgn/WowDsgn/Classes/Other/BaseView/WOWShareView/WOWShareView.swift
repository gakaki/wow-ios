//
//  WOWShareView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/23.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPopView:UIView{
    var customerView:UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    convenience init(frame: CGRect,customerView:UIView!) {
        self.init(frame:frame)
        self.customerView = customerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUP(){
        self.backgroundColor = MaskColor
    }

    lazy var popWindow:UIWindow = {
        let w = UIApplication.sharedApplication().delegate as! AppDelegate
        return w.window!
    }()
    
    func show() {
        
    }
}


class WOWShareView: UIView {
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var wechatView: UIView!
    @IBOutlet weak var weiboView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        friendView.addTapGesture {[weak self](tap) in
//            if let strongSelf = self{
//                
//            }
//        }
//        
//        wechatView.addTapGesture {[weak self](tap) in
//            if let strongSelf = self{
//                
//            }
//        }
//        
//        weiboView.addTapGesture {[weak self](tap) in
//            if let strongSelf = self{
//                
//            }
//        }
    }
    
}
