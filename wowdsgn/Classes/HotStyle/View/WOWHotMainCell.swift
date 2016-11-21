//
//  WOWHotMainCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWHotMainCell: UITableViewCell {

    @IBOutlet weak var imgBack: UIImageView!
    private var shareProductImage:UIImage? //供分享使用
    @IBOutlet weak var lbWOWTitle: UILabel! // 左上角栏目
    @IBOutlet weak var btnLike: UIButton! // 点赞按钮

    @IBOutlet weak var lbPraise: UILabel!//多少人看
    @IBOutlet weak var lbTitleMain: UILabel!// 主标题
    @IBOutlet weak var lbBrowse: UILabel!//多少人赞
    @IBOutlet weak var lbTime: UILabel!//发布时间
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ m:WOWHotStyleModel)  {
        
        lbWOWTitle.text = m.columnName?.get_formted_Space()
        if let url = m.topicImg {
        
            
            let image_place_holder = UIImage(named: "placeholder_product")
            var res :String?
            switch UIDevice.deviceType {
            case .dt_iPhone4S,.dt_iPhone5:
                res     = "\(url)?imageView2/0/w/500/format/webp/q/90"
            case .dt_iPhone6:
                res     = "\(url)?imageView2/0/w/700/format/webp/q/90"
            case .dt_iPhone6_Plus:
                res     = "\(url)?imageView2/0/w/900/format/webp/q/90"
            default:
                res     = "\(url)?imageView2/0/w/700/format/webp/q/90"
                
            }
            let url_obj            = URL(string:res ?? "")
            imgBack.yy_setImage(with: url_obj,
                                placeholder: image_place_holder,
                                completion: { [weak self](image, url, cacheType, webImage, error) in
                                    if let strongSelf = self{
                                        strongSelf.shareProductImage = image
                                    }
            })

        }
        
        if m.likeQty == 0 {
            lbBrowse.text = ""
        }else{
            lbBrowse.text    = m.likeQty?.toString
        }
        if m.readQty == 0 {
            lbPraise.text = ""
        }else{
            lbPraise.text    = m.readQty?.toString
        }
        lbTitleMain.text     = m.topicMainTitle
        let timerNumber      = (m.publishTime ?? 0)/1000
        lbTime.text          = timerNumber.getTimeString()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
