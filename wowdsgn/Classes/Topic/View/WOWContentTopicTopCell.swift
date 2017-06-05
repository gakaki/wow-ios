//
//  WOWContentTopicTopCell.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol WOWContentTopicTopCellDelegate: class {
    func columnGoTopic(_ columnId: Int?, topicTitle title: String?)
}

class WOWContentTopicTopCell: UITableViewCell {
    
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicDesc: UILabel!
    @IBOutlet weak var publicTime: UILabel!
    @IBOutlet weak var columnName: UILabel!
    @IBOutlet weak var columnView: UIView!
    @IBOutlet weak var columnBtn: UIButton!
    @IBOutlet weak var aspect: NSLayoutConstraint!
    
    weak var delegeta: WOWContentTopicTopCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(_ model: WOWContentTopicModel?) {
        if let model = model {
            if let img = model.topicImg {
                topicImg.set_webimage_url(img)

            }

            columnName.text = model.columnName ?? ""
            if columnName.text == "" {
                columnView.isHidden = true
                columnBtn.isHidden = true
            }else {
                columnView.isHidden = false
                columnBtn.isHidden = false
            }
            
            
            columnBtn.addAction({[weak self] in
                if let strongSelf = self {
                    if let del = strongSelf.delegeta {
                        del.columnGoTopic(model.columnId, topicTitle: model.columnName)
                    }
                }
            })
            if let publishTime = model.publishTime{
                let timeStr = (publishTime/1000).getTimeString()
                publicTime.text = String(format:"发布于%@", timeStr)
            }else {
                publicTime.text = String(format:"发布于刚刚")

            }
            topicTitle.text = model.topicName
            topicTitle.setLineHeightAndLineBreak(1.2)
            topicDesc.text = model.topicDesc
            topicDesc.setLineHeightAndLineBreak(1.5)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
    }
  
    
}
