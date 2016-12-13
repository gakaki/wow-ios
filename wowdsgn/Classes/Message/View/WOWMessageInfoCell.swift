//
//  WOWMessageInfoCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol WOWMessageInfoCellDelegate:class {
    func goMsgDetail(model: WOWMessageModel)
}

class WOWMessageInfoCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var tapView: UIView!
    weak var delegate: WOWMessageInfoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        newView.setCornerRadius(radius: 4)
        // Initialization code
    }

    func  showData(model: WOWMessageModel?) {
        if let model = model {
            timeLabel.text = model.createTime
            msgTitle.text = model.msgTitle
            msgContent.text = model.msgContent
            if model.isRead ?? false {
                newView.isHidden = true
            }else {
                newView.isHidden = false
            }
            tapView.addAction({[weak self] in
                if let strongSelf = self {
                    if let del = strongSelf.delegate {
                        del.goMsgDetail(model: model)
                    }
                }
            })
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
