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
    var modelData : WOWTopicCommentListModel?// 主信息
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImageView.borderRadius(15)
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
            
            if model.favoriteQty > 0 {
                numberLabel.text = String(format:"%i", model.favoriteQty ?? 0)
            }else {
                numberLabel.text = ""
            }
            thumbButton.isSelected = model.favorite ?? false
        }
        
    }
    
    // 点赞按钮
    @IBAction func clickLikeAction(sender: UIButton) {
        
        WOWClickLikeAction.requestLikeComment(commentId: modelData?.commentId ?? 0,view: self,btn: sender) { [weak self](isFavorite) in
            
            if let strongSelf = self{
                
                strongSelf.thumbButton.isSelected = isFavorite ?? false
                // 接口那边通过 请求这个页面的接口计算有多少人查看，如果此时调用这个接口拉新数据的话，会多一次请求，会造成一下两次的情况产生 ，所以前端处理 自增减1
                strongSelf.modelData?.favoriteQty = Calculate.calculateType(type: isFavorite!)(strongSelf.modelData?.favoriteQty ?? 0)
                
                var thumbNum = strongSelf.modelData?.favoriteQty ?? 0
                thumbNum     = (thumbNum < 0 ? 0:thumbNum)
                if thumbNum == 0 {
                    strongSelf.numberLabel.text = ""
                }else{
                    strongSelf.numberLabel.text    = thumbNum.toString
                }
                strongSelf.modelData?.favorite = isFavorite
                
            }
            
        }
        
    }


}
