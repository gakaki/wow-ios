//
//  WOWMenuCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWMenuCell: UITableViewCell {

    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuNameLabel: UILabel!
    @IBOutlet var menuCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var imageName: UIImageView!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showDataModel(model:WOWMenuModel){
        menuImageView.image = UIImage(named:model.menuImage ?? "")
        menuNameLabel.text = model.menuName
        menuCountLabel.text = model.menuCount
    }
    
}
