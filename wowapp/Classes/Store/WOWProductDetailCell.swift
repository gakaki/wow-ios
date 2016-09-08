//
//  WOWProductDetailCell.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailCell: UITableViewCell {
    @IBOutlet weak var productImg:UIImageView!
    @IBOutlet weak var imgDescLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(secondaryImg: WOWProductPicTextModel?) {
        if let secondaryImg = secondaryImg {
            
            productImg.kf_setImageWithURL(NSURL(string:secondaryImg.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
//            productImg.set_webimage_url_base(secondaryImg.image, place_holder_name: "placeholder_product")
            imgDescLabel.text = secondaryImg.text
            imgDescLabel.setLineHeightAndLineBreak(1.5)
        }
    }
    
}
