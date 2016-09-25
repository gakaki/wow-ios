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
        let v = Bundle.loadResourceName(String(describing: WOWSelectPayView.self)) as! WOWSelectPayView
        v.closeButton.addTarget(self, action: #selector(closeButtonClick), for:.touchUpInside)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var backClear:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
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
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
//        b.addTarget(self, action: #selector(hidePayView), forControlEvents:.TouchUpInside)
        return b
    }()
    //MARK:Private Method
    fileprivate func setUP(){
        self.frame = CGRect(x: 0, y: 0, width: self.w, height: self.h)
        backgroundColor = MaskColor
        self.alpha = 0
    }
    
    
    
    //MARK:Actions
    func show() {
        backClear.frame = CGRect(x: 0,y: self.h,width: self.w,height: self.h)
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    
    func closeButtonClick()  {
        if let del = payView.delegate {
            del.canclePay()
        }
        hidePayView()
    }
    
    func hidePayView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backClear.y = self.h + 10
            self.alpha = 0
        }, completion: { (ret) in
            self.removeFromSuperview()
        }) 
    }
    
    
}

protocol selectPayDelegate: class {
    //确定支付
    func surePay(_ channel: String)
    //取消支付
    func canclePay()
}

class WOWSelectPayView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var alipayButton: UIButton!
    @IBOutlet weak var weixinButton: UIButton!
    
    weak var delegate: selectPayDelegate?
    var channel: String! //支付方式
    
    
    //MARK: - Action
    @IBAction func alipayClick(_ sender: UIButton) {
        if alipayButton.isSelected {
            alipayButton.isSelected = false
            channel = ""
            return
        }
        weixinButton.isSelected = false
        alipayButton.isSelected = true
        channel = "alipay"
    }
    
    @IBAction func weixinClick(_ sender: UIButton) {
        if weixinButton.isSelected {
            weixinButton.isSelected = false
            channel = ""
            return
        }
        alipayButton.isSelected = false
        weixinButton.isSelected = true
        channel = "wx"
    }

    @IBAction func sureClick(_ sender: UIButton) {
        if !weixinButton.isSelected && !alipayButton.isSelected{
            WOWHud.showMsg("请选择支付方式")
            return
        }
        if let del = delegate {
            
            del.surePay(channel)
        }
        
    }
}
