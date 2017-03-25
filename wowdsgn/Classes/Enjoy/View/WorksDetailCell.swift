//
//  TextDetailCell.swift
//  PhotoTweaks-Demo
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class WorksDetailCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var imgMyPhoto: UIImageView!
    
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var lbMyName: UILabel!
    
    @IBOutlet weak var lbMyIntro: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         imgMyPhoto.set_webimage_url_user( WOWUserManager.userHeadImageUrl )
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
