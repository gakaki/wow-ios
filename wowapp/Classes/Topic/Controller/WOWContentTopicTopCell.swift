//
//  WOWContentTopicTopCell.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWContentTopicTopCell: UITableViewCell {
    
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(model: WOWModelVoTopic?) {
        labelWidth.constant = MGScreenWidth*0.7
    }
}
