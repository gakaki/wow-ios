//
//  WOWUserHeaderView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/23.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWUserHeaderView: UIView {

    @IBOutlet weak var userBack: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var workNum: UILabel!
    @IBOutlet weak var praiseNum: UILabel!
    @IBOutlet weak var favoriteNum: UILabel!
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
    
    func configUserInfo() {
        
    }

    
}
