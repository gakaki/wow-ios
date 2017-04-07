//
//  WOWGuideView.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/6.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterGuideView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight)
        self.addTapGesture { [unowned self](tap) in
            self.hideView()
        }
        // Initialization code
    }
    func hideView(){
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.layoutIfNeeded()
                
            }
            
            }, completion: {[weak self] (ret) in
                if let strongSelf = self {
                    strongSelf.removeFromSuperview()
                    
                }
        })
    }
    
    

}
