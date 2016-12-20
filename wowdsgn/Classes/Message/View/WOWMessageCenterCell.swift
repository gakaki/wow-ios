//
//  WOWMessageCenterCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageCenterCell: UITableViewCell {
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var msgImg: UIImageView!
    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        newView.setCornerRadius(radius: 4)
        // Initialization code
    }
    
    func showData(model: WOWMessageModel?) {
        if let model = model {
            ///1为系统消息；2为官方消息
            if model.msgType == 1 {
                msgImg.image = UIImage(named: "systemInfo")
                msgTitle.text = "系统消息"
            }else{
                msgImg.image = UIImage(named: "officialInfo")
                msgTitle.text = "官方消息"
            }
            //如果未读消息大于0，显示未读标示
            if model.unReadCount > 0 {
                newView.isHidden = false
            }else {
                newView.isHidden = true
            }
            msgContent.text = model.msgContent
            timeLabel.text = model.createTime?.stringToTimeStamp()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
