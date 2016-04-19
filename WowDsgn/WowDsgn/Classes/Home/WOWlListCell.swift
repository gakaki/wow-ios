//
//  WOWlListCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWlListCell: UITableViewCell {

    @IBOutlet var bigImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(model:WOWSenceModel) {
//        let url = model.image
//        bigImageView.kf_setImageWithURL(<#T##URL: NSURL##NSURL#>, placeholderImage: <#T##Image?#>)
        dateLabel.text = model.senceTime
        titleLabel.text = model.senceName
    }
}
