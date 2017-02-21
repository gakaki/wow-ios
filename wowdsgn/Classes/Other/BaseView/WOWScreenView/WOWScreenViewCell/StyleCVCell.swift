//
//  StyleCVCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/15.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class StyleCVCell: UICollectionViewCell {
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(m: ScreenModel)  {
        lbTitle.text = m.name
        if m.isSelect == true {
            imgSelect.image = UIImage.init(named: "select")
        }else{
            imgSelect.image = UIImage.init(named: "screen_choice")
        }
    }

}
