//
//  WOWTaxExplainCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/15.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWTaxExplainCell: UITableViewCell {

    @IBOutlet weak var taxImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ logisticsMode: Int?){
        if let logisticsMode = logisticsMode {
            switch logisticsMode {
            case 1:     //海外直邮
                taxImg.image = UIImage(named: "tax2")
            case 2:     //保税区直邮
                taxImg.image = UIImage(named: "tax1")
            default:
                taxImg.image = UIImage(named: "placeholder_product")
            }
        }
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
