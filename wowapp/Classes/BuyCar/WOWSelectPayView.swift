//
//  WOWSelectPayView.swift
//  wowapp
//
//  Created by 安永超 on 16/8/4.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
//MARK:*****************************背景视图******************************************

class WOWPayBackView: UIView {
    //MARK:Lazy
    lazy var payView:WOWSelectPayView = {
        let v = NSBundle.loadResourceName(String(WOWSelectPayView)) as! WOWSelectPayView
        v.closeButton.addTarget(self, action: #selector(closeButtonClick), forControlEvents:.TouchUpInside)
        v.userInteractionEnabled = true
        return v
    }()
    
    lazy var backClear:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dismissButton:UIButton = {
        let b = UIButton(type: .System)
        b.backgroundColor = UIColor.clearColor()
//        b.addTarget(self, action: #selector(hidePayView), forControlEvents:.TouchUpInside)
        return b
    }()
    //MARK:Private Method
    private func setUP(){
        self.frame = CGRectMake(0, 0, self.w, self.h)
        backgroundColor = MaskColor
        self.alpha = 0
    }
    
    
    
    //MARK:Actions
    func show() {
        backClear.frame = CGRectMake(0,self.h,self.w,self.h)
        addSubview(backClear)
        backClear.addSubview(payView)
        payView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
            }
        }
        backClear.insertSubview(dismissButton, belowSubview: payView)
        dismissButton.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf.backClear).offset(0)
                make.bottom.equalTo(strongSelf.payView.snp_top).offset(0)
            }
        }
        
        UIView.animateWithDuration(0.3) {
            self.alpha = 1
            self.backClear.y = 0
        }
    }
    
    func closeButtonClick()  {
        hidePayView()
    }
    
    func hidePayView(){
        UIView.animateWithDuration(0.3, animations: {
            self.backClear.y = self.h + 10
            self.alpha = 0
        }) { (ret) in
            self.removeFromSuperview()
        }
    }
    
    
}

protocol selectPayDelegate: class {
    //确定支付
    func surePay(channel: String)
}

class WOWSelectPayView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var alipayButton: UIButton!
    @IBOutlet weak var weixinButton: UIButton!
    
    weak var delegate: selectPayDelegate?
    var channel: String! //支付方式
    
    
    //MARK: - Action
    @IBAction func alipayClick(sender: UIButton) {
        weixinButton.selected = false
        alipayButton.selected = true
        channel = "alipay"
    }
    
    @IBAction func weixinClick(sender: UIButton) {
        alipayButton.selected = false
        weixinButton.selected = true
        channel = "wx"
    }

    @IBAction func sureClick(sender: UIButton) {
        if !weixinButton.selected && !alipayButton.selected{
            WOWHud.showMsg("请选择支付方式")
            return
        }
        if let del = delegate {
            
            del.surePay(channel)
        }
        
    }
}
