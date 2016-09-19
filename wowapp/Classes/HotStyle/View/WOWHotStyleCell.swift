//
//  WOWHotStyleCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol WOWHotStyleCellDelegate:class {
    func reloadTableViewDataWithCell()
}
class WOWHotStyleCell: UITableViewCell {

    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lbLogoName: UILabel!// 左上角logo名字
    @IBOutlet weak var imgLogo: UIImageView!// 左上角logo 图片
    @IBOutlet weak var lbPraise: UILabel!//多少人看
    @IBOutlet weak var lbTitleMain: UILabel!// 主标题
    @IBOutlet weak var lbBrowse: UILabel!//多少人赞
    @IBOutlet weak var imgBackMain: UIImageView!// 背景图片
    private var shareProductImage:UIImage? //供分享使用
    
    weak var    delegate   :  WOWHotStyleCellDelegate?
    var brandModel : WOWBrandStyleModel?
    var modelData : WOWModelVoTopic?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // 点赞按钮
    @IBAction func clickLikeAction(sender: AnyObject) {
        
        WOWClickLikeAction.requestLikeProject(modelData?.id ?? 0) { [weak self](isFavorite) in
            if let strongSelf = self{
                
                strongSelf.delegate?.reloadTableViewDataWithCell()

            }
            
        }
        
    }
    func showData(model: WOWHomeModle)  {
        
        if let brandModel = model.moduleContentList?.brand {
            modelData = model.moduleContentList
            lbLogoName.text = brandModel.brandEname
            imgLogo.set_webimage_url_base(brandModel.brandLogoImg, place_holder_name: product)
            
        }else{
            lbLogoName.text = " "
            imgLogo.image = nil
        }
        if let moduleImage = model.moduleAdditionalInfo?.imageUrl {
            
            imgBackMain.kf_setImageWithURL(NSURL(string: moduleImage ?? "")!, placeholderImage:nil, optionsInfo: nil) {[weak self](image, error, cacheType, imageURL) in
                if let strongSelf = self{
                    strongSelf.shareProductImage = image
                }
            }

            
            
            imgBackMain.set_webimage_url_base(moduleImage, place_holder_name: product)
        }
        if let showTitle =  model.moduleAdditionalInfo?.showTitle {
            if showTitle { // true 则显示label  false 则不显示
                
                if let modultTitle = model.moduleAdditionalInfo?.title {
                    
                    lbTitleMain.text = modultTitle
                    
                }

            }else{
                    lbTitleMain.text = ""
            }
        }
        
            lbBrowse.text    = model.moduleContentList?.likeQty?.toString

            lbPraise.text    = model.moduleContentList?.readQty?.toString
            btnLike.selected = model.moduleContentList?.favorite ?? false

    }
    @IBAction func shareClick(sender: UIButton) {
        let shareUrl = WOWShareUrl + "/topic/\(modelData?.id ?? 0)"
        WOWShareManager.share(modelData?.topicName, shareText: modelData?.topicDesc, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
