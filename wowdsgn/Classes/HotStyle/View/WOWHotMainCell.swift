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
    private var shareProductImage:String? //供分享使用
    @IBOutlet weak var lbWOWTitle: UILabel! // 左上角栏目
    @IBOutlet weak var btnLike: UIButton! // 点赞按钮

    @IBOutlet weak var lbPraise: UILabel!//多少人看
    @IBOutlet weak var lbTitleMain: UILabel!// 主标题
    @IBOutlet weak var lbBrowse: UILabel!//多少人赞
    @IBOutlet weak var lbTime: UILabel!//发布时间
    @IBOutlet weak var bottomView:UIView!// 底部装在点赞按钮的View
    private var modelData:WOWHotStyleModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // 点赞按钮
    @IBAction func clickLikeAction(sender: AnyObject) {
        
        WOWClickLikeAction.requestLikeProject(topicId: modelData?.id ?? 0,view: self.bottomView,btn: sender as! UIButton) { [weak self](isFavorite) in
            
            if let strongSelf = self{

                strongSelf.btnLike.isSelected = isFavorite ?? false
                // 接口那边通过 请求这个页面的接口计算有多少人查看，如果此时调用这个接口拉新数据的话，会多一次请求，会造成一下两次的情况产生 ，所以前端处理 自增减1
                strongSelf.modelData?.favoriteQty = Calculate.calculateType(type: isFavorite!)(strongSelf.modelData?.favoriteQty ?? 0)
                
                var thumbNum = strongSelf.modelData?.favoriteQty ?? 0
                thumbNum     = (thumbNum < 0 ? 0:thumbNum)
                if thumbNum == 0 {
                    strongSelf.lbBrowse.text = ""
                }else{
                    strongSelf.lbBrowse.text    = thumbNum.toString
                }
                strongSelf.modelData?.favorite = isFavorite

            }
            
        }
        
    }
    func showData(_ m:WOWHotStyleModel)  {
        modelData = m
        lbWOWTitle.text = m.columnName?.get_formted_Space()
        shareProductImage = m.topicImg
//        if let url = m.topicImg {
        
            
//            let image_place_holder = UIImage(named: "placeholder_product")
//            var res :String?
//            switch UIDevice.deviceType {
//            case .dt_iPhone4S,.dt_iPhone5:
//                res     = "\(url)?imageView2/0/w/500/format/webp/q/90"
//            case .dt_iPhone6:
//                res     = "\(url)?imageView2/0/w/700/format/webp/q/90"
//            case .dt_iPhone6_Plus:
//                res     = "\(url)?imageView2/0/w/900/format/webp/q/90"
//            default:
//                res     = "\(url)?imageView2/0/w/700/format/webp/q/90"
//                
//            }
//            let url_obj            = URL(string:res ?? "")
            imgBack.set_webimage_url(m.topicImg)
//            imgBack.yy_setImage(with: url_obj,
//                                placeholder: image_place_holder,
//                                completion: { [weak self](image, url, cacheType, webImage, error) in
//                                    if let strongSelf = self{
//                                        strongSelf.shareProductImage = image
//                                    }
//            })

//        }
        
        if m.favoriteQty == 0 {
            lbBrowse.text = ""
        }else{
            lbBrowse.text    = m.favoriteQty?.toString
        }
        if m.readQty == 0 {
            lbPraise.text = ""
        }else{
            lbPraise.text    = m.readQty?.toString
        }
        lbTitleMain.text     = m.topicName
        let timerNumber      = (m.publishTime ?? 0)/1000
        lbTime.text          = timerNumber.getTimeString()
        btnLike.isSelected   = m.favorite ?? false
    }
    
    @IBAction func shareClick(sender: UIButton) {
        let shareUrl = WOWShareUrl + "/topic/\(modelData?.id ?? 0)"
        WOWShareManager.share(modelData?.topicName, shareText: modelData?.topicDesc, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
