//
//  WOWCMBCAlterView.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/25.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCMBCAlterView: ETPopupView {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var bindMobileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        animationDuration = 0.3
        type = .alert
        
//        ETPopupWindow.sharedWindow().touchWildToHide = false
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(MGScreenWidth*0.8)
            
        }
    }
    
//    @IBAction func close(_ sender: UIButton) {
//        hideWithBlock { [weak self](view, finish) in
//            if let strongSelf = self {
//                if finish {
//                    
//                    VCRedirect.toOrderDetail(orderCode: strongSelf.orderCode, .orderPay)
//                }
//            }
//            
//            
//        }
//    }
//    
//    @IBAction func goBingMobile(_ sender: UIButton) {
//
//       hideWithBlock { (view, finish) in
//            if finish {
//                
//                VCRedirect.bingMobileSecond(entrance: .editOrder)
//
//            }
//        
//        }
//    }

}
