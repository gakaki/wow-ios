//
//  WOWProductDesCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/21.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWProductDesCell: UITableViewCell {

    @IBOutlet weak var exemptionLb: UILabel!    //第一个标签
    @IBOutlet weak var logisticsLb: UILabel!    //第三个标签
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(_ model:WOWProductModel?){

        if let model = model {
            if model.isOversea ?? false {
                exemptionLb.text = "包税包邮"
                if let logisticsMode = model.logisticsMode {
                    if logisticsMode == 1 {
                        logisticsLb.text = "海外直邮"
                    }else {
                        logisticsLb.text = "14天到货"
                    }
                }
            }else {
                exemptionLb.text = "满99包邮"
                logisticsLb.text = "七天退换"
            }
            
         
        }
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
