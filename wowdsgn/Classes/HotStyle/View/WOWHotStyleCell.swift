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
        
        WOWClickLikeAction.requestLikeProject(topicId: modelData?.id ?? 0,view: self,btn: sender as! UIButton) { [weak self](isFavorite) in
            
            if let strongSelf = self{
                
                // strongSelf.request()
                
                // 接口那边通过 请求这个页面的接口计算有多少人查看，如果此时调用这个接口拉新数据的话，会多一次请求，会造成一下两次的情况产生 ，所以前端处理 自增减1
                strongSelf.modelData?.likeQty = Calculate.calculateType(type: isFavorite!)(strongSelf.modelData?.likeQty ?? 0)
                
                var thumbNum = strongSelf.modelData?.likeQty ?? 0
                thumbNum     = (thumbNum < 0 ? 0:thumbNum)
                if thumbNum == 0 {
                    strongSelf.lbBrowse.text = ""
                }else{
                    strongSelf.lbBrowse.text    = thumbNum.toString
                }
                
                strongSelf.btnLike.isSelected = isFavorite ?? false
                
            }
            
        }
        
    }
    func showData(model: WOWHomeModle)  {
        
        if let brandModel = model.moduleContentList?.brand {
            lbLogoName.text = brandModel.brandEname
            imgLogo.set_webimage_url_base(brandModel.brandLogoImg, place_holder_name: product)
            imgLogo.borderRadius(20)
        }else{
            lbLogoName.text = " "
            imgLogo.image = nil
        }
        if let moduleImage = model.moduleAdditionalInfo?.imageUrl {
            
            imgBackMain.kf.setImage(
                with: URL(string:moduleImage )!,
                placeholder: nil,
                options: nil,
                progressBlock: { (arg1, arg2) in
                    
                    
                },
                completionHandler: { [weak self](image, error, cacheType, imageUrl) in
                    if let strongSelf = self{
                        strongSelf.shareProductImage = image
                    }
                }
            )

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
        
        
        if model.moduleContentList?.likeQty == 0 {
            lbBrowse.text = ""
        }else{
            lbBrowse.text    = model.moduleContentList?.likeQty?.toString
        }
        if model.moduleContentList?.readQty == 0 {
            lbPraise.text = ""
        }else{
            lbPraise.text    = model.moduleContentList?.readQty?.toString
        }
        
        btnLike.isSelected = model.moduleContentList?.favorite ?? false
        
        
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
