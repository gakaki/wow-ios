//
//  Cell_105_SingBrand.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class Cell_105_SingBrand: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 105
    }
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgBrand: UIImageView!
    @IBOutlet weak var lbBrandTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
