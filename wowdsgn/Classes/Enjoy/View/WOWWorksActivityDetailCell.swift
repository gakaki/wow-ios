//
//  WOWWorksActivityDetailCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/5.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksActivityDetailCell: UITableViewCell {
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var picNumLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picHeight: NSLayoutConstraint!
    
    var topicModel: WOWActivityModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showData(model: WOWActivityModel?) {
        if let model = model {
            topicImg.set_webimage_url(model.img)
            picHeight.constant = model.picHeight
            picNumLabel.text = String(format: "%i", model.instagramQty ?? 0)
            switch model.status ?? 0 {
            case 0:
                timeLabel.text = String(format: "距离活动开始还有%i天", model.offset ?? 0)
            case 1:
                timeLabel.text = String(format: "距离活动结束还有%i天", model.offset ?? 0)
            case 2:
                timeLabel.text = "活动已结束"
                
            default:
                timeLabel.text = String(format: "距离活动开始还有%i天", model.offset ?? 0)
                
            }
            titleLabel.text = model.title
            contentLabel.text = model.content
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
