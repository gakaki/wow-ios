//
//  WOWPraiseThreeCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWPraiseThreeCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var v_height: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        v_height.constant = (MGScreenWidth - 12)/3

        // Initialization code
    }
    
    func showData(model: WOWWorksListModel?) {
        if let model = model {
            imgView.set_webimage_url(model.pic)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
