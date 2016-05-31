//
//  WOWShareView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/23.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum WOWShareType:String{
    case friends
    case wechat
    case weibo
}

typealias ShareViewAction = (shareType:WOWShareType) -> Void

class WOWShareBackView:UIView{
    var shareActionBack : ShareViewAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backClear:UIView! = {
        let v = UIView(frame:CGRectMake(0, self.h, self.w, self.h))
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    
    lazy var shareView:WOWShareView = {
       let v = NSBundle.mainBundle().loadNibNamed(String(WOWShareView), owner: self, options: nil).last as! WOWShareView
        v.friendView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(shareType: WOWShareType.friends)
                }
                strongSelf.dismiss()
            }
        }
        
        v.wechatView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(shareType: WOWShareType.wechat)
                }
                strongSelf.dismiss()
            }
        }
        
        v.weiboView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(shareType: WOWShareType.weibo)
                }
                strongSelf.dismiss()
            }
        }
        return v
    }()
    
    private func setUP(){
        self.backgroundColor = MaskColor
        self.alpha = 0
        self.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.dismiss()
            }
        }
    }

    lazy var popWindow:UIWindow = {
        let w = UIApplication.sharedApplication().delegate as! AppDelegate
        return w.window!
    }()
    
    func show() {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(shareView)
        shareView.snp_makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }
        UIView.animateWithDuration(0.3) {
            self.alpha = 1
            self.backClear.y = 0
        }
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3,animations: {
            self.alpha = 0
            self.backClear.y = MGScreenHeight + 10;
        }){ (ret) in
            self.removeFromSuperview()
        }
    }
}


class WOWShareView: UIView {
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var wechatView: UIView!
    @IBOutlet weak var weiboView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
