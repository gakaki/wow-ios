//
//  WOWCommentCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWCommentCell: UITableViewCell {

    
    @IBOutlet weak var headImageWidth: NSLayoutConstraint!
    @IBOutlet weak var headImageLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        headImageView.borderRadius(22)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hideHeadImage() {
        headImageView.hidden = true
        headImageWidth.constant = 0
        headImageLeftMargin.constant = 0
    }
    
    func showData(model:WOWCommentListModel) {
        self.headImageView.kf_setImageWithURL(NSURL(string: model.user_headimage ?? "")!, placeholderImage:UIImage(named: "placeholder_userhead"))
        
//        self.headImageView.set_webimage_url_user( model.user_headimage! )

        dateLabel.text = model.created_at
        commentLabel.text = model.comment
        if model.user_nick == nil {
            if model.mobile == nil {
                if model.email == nil {
                    nameLabel.text = model.email
                }
            }else{
                nameLabel.text = model.mobile
            }
        }else{
            nameLabel.text = model.user_nick
        }
    }

}
