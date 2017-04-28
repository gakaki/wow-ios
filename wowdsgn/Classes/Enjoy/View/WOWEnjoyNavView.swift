//
//  WOWEnjoyNavView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/23.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWEnjoyNavView: UIView {
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: 114, height: 44)
    
        // Initialization code
    }
}
