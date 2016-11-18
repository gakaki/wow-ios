//
//  WOWColumnCVCelll.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWColumnCVCelll: UICollectionViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ m : WOWHomeHot_1001_title)  {
        
        lbTitle.text = m.name
        imgIcon.set_webimage_url(m.icon)
    }
}
