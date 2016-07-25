//
//  WOWAddressCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAddressCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
        
    }

    func showData(model:WOWAddressListModel)  {
        nameLabel.text = model.name
        phoneLabel.text = model.mobile
        detailAddressLabel.text = model.full_address
        if model.isDefault  == 1{
            checkButton.setImage(UIImage(named: "select"), forState: .Normal)
        }else {
            checkButton.setImage(UIImage(named: "car_check"), forState: .Normal)
        }
        
    }
    
}
