//
//  WOWProductDetailTipsCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailTipsCell: UITableViewCell {

    @IBOutlet weak var telButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
//    @IBOutlet weak var customerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        telButton.addBorder(width: 1, color:UIColor.blackColor())
//        customerButton.addBorder(width: 1, color:UIColor.blackColor())
    }
    
    @IBAction func callClick(sender: UIButton) {
        WOWTool.callPhone()
    }
    
//    @IBAction func customerServiceClick(sender: UIButton) {
//        DLog("在线客服")
//    }
    
}
