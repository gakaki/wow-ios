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
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? = nil{
        didSet {
            if oldValue != nil {
                //删除旧的约束
                LayoutConstraint.deactivate([oldValue!])
            }
            if aspectConstraint != nil {
                LayoutConstraint.activate([aspectConstraint!])
                
            }
        }
    }

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
                topicImg.yy_setImage(
                    with: URL(string:img.webp_url()),
                    placeholder: UIImage(named: "placeholder_product"),
                    options: [YYWebImageOptions.progressiveBlur , YYWebImageOptions.setImageWithFadeAnimation],
                    completion: {[weak self] (img, url, from_type, image_stage,err ) in
                        if let strongSelf = self {
                            if let image = img {
                                let imageAspect = image.size.width / image.size.height
                                strongSelf.aspectConstraint = NSLayoutConstraint(item: strongSelf.topicImg,
                                                                                 attribute: .width, relatedBy: .equal,
                                                                                 toItem: strongSelf.topicImg, attribute: .height,
                                                                                 multiplier: imageAspect , constant: 0.0)
                            }
                        }
                })

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
            topicDesc.text = model.topicDesc
            topicDesc.setLineHeightAndLineBreak(1.5)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
        aspectConstraint = nil
    }
  
    
}
