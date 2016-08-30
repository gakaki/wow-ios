//
//  WOWProductHeaderView.swift
//  wowapp
//
//  Created by 安永超 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductHeaderView: UIView {
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var openImg: UIImageView!
    func isOpen(isOpen: Bool = false) {
        if isOpen {
            openImg.image = UIImage(named: "down")
        }else {
            openImg.image = UIImage(named: "next_arrow")
        }
    }
}
