//
//  WOWOrderAddressCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/4.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderAddressCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var addAddressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  showData(addressInfo: WOWAddressListModel?) -> Void {
        if let addressInfo = addressInfo {
            addAddressLabel.hidden = true
            nameLabel.text = addressInfo.name ?? ""
            mobileLabel.text = addressInfo.mobile ?? ""
            addressLabel.text = (addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? "") + (addressInfo.addressDetail ?? "")
        }else {
            nextImage.hidden = true
            nameLabel.hidden = true
            mobileLabel.hidden = true
            addressLabel.hidden = true
        }
    
    }
    
}
