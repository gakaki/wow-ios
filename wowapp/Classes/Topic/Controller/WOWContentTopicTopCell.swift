//
//  WOWContentTopicTopCell.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWContentTopicTopCell: UITableViewCell {
    
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(_ model: WOWModelVoTopic?) {
        if let model = model {
            topicImg.set_webimage_url(model.topicImg)
            topicTitle.text = model.topicMainTitle
            topicDesc.text = model.topicDesc
            topicDesc.setLineHeightAndLineBreak(1.5)
        }
    }
}
