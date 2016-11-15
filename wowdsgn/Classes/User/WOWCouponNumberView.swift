//
//  WOWCouponheaderView.swift
//  wowapp
//
//  Created by 安永超 on 16/8/15.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol WOWCouponNumberViewDelegate:class{
    func convertCouponClick(_ textField: String)
}

class WOWCouponNumberView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    weak var delegate : WOWCouponNumberViewDelegate?

    
    @IBAction func convertButtonClick(_ sender: UIButton) {
        if let text = textField.text {
            if text.isEmpty {
                WOWHud.showMsg("请输入优惠码")
                return
            }
            if let del = delegate {
                textField.resignFirstResponder()
                del.convertCouponClick(text)
            }
        }
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        textField.resignFirstResponder()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
