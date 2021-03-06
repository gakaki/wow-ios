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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func  showData(_ addressInfo: WOWAddressListModel?) -> Void {
        if let addressInfo = addressInfo {
            nextImage.isHidden = false
            nameLabel.isHidden = false
            mobileLabel.isHidden = false
            addressLabel.isHidden = false
            addAddressLabel.isHidden = true
            nameLabel.text = addressInfo.name ?? ""
            if let mobile = addressInfo.mobile {
                if mobile.length > 7 {
                    mobileLabel.text = addressInfo.mobile!.get_formted_xxPhone()
                }
            }
            addressLabel.text = (addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? "") + (addressInfo.addressDetail ?? "")
        }else {
            nextImage.isHidden = true
            nameLabel.isHidden = true
            mobileLabel.isHidden = true
            addressLabel.isHidden = true
            addAddressLabel.isHidden = false

        }
    
    }
    
}
