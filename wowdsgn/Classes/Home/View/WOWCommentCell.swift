//
//  WOWCommentCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWCommentCell: UITableViewCell {

    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var thumbButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        headImageView.borderRadius(22)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hideHeadImage() {
        headImageView.isHidden = true
       
    }
    
    func showData(_ model: WOWTopicCommentListModel?) {
        if let model = model {
            headImageView.set_webimage_url(model.userAvatar)
            commentLabel.text = model.content
            nameLabel.text = model.userName
            if let publishTime = model.createTime {
                let timeStr = (publishTime/1000).getTimeString()
                dateLabel.text = timeStr
            }
            
            if model.favoriteCount > 0 {
                numberLabel.text = String(format:"%i", model.favoriteCount ?? 0)
            }
        }
        
    }

}
