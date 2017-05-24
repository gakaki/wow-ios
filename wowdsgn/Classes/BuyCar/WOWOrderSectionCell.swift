//
//  WOWOrderSectionCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/17.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOrderSectionCell: UITableViewCell {

    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var taxImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showData(index: Int, isOrdersea: Bool) {
        orderTitle.text = String(format: "订单%i",index)
        if isOrdersea {
            taxImg.isHidden = false
        }else {
            taxImg.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
