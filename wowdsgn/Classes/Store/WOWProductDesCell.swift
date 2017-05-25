//
//  WOWProductDesCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/21.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWProductDesCell: UITableViewCell {

    @IBOutlet weak var exemptionLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(_ model:WOWProductModel?){

        if let model = model {
            if model.isOversea ?? false {
                exemptionLb.text = "包邮包税"
            }else {
                exemptionLb.text = "满99包邮"
            }
        }
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
