//
//  WOWSearchBarView.swift
//  Wow
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSearchBarView: UIView {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.borderRadius(15)
        backView.borderColor(0.5, borderColor:SeprateColor)
        backView.shadow()
    }

}
