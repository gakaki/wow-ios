//
//  WOWReturnGoodsCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWReturnGoodsCell: WOWStyleNoneCell {

    @IBOutlet weak var lbLogisticsNumber: UITextField!
    @IBOutlet weak var lbAddressDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
           lbLogisticsNumber.addBorder(width: 1, color: UIColor.init(hexString: "eaeaea")!)
    }
    
    @IBAction func commitClickAction(_ sender: Any) {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
