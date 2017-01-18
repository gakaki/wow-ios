//
//  WOWSearchBrandCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/1/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWSearchBrandCell: UITableViewCell {
    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(model: WOWBrandV1Model?) {
        if let model = model {
            brandImg.set_webimage_url(model.image)
            brandName.text = String(format: "品牌：%@", model.name ?? "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
