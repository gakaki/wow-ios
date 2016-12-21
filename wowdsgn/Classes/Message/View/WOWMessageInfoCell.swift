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
            //格式化时间
            timeLabel.text = model.createTime?.stringToTimeStamp()
            msgTitle.text = model.msgTitle
            msgContent.text = model.msgContent
            //判断是否已读，如果读了不显示标致
            if model.isRead ?? true {
                newView.isHidden = true
            }else {
                newView.isHidden = false
            }
            tapView.addAction({[weak self] in
                if let strongSelf = self {
                    if let del = strongSelf.delegate {
                        //跳转页面
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
