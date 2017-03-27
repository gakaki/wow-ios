//
//  WOWUserHeaderView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/23.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWUserHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 9/16*MGScreenWidth)
        
    }

    
}
