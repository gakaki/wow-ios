//
//  Cell_501_Recommend.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/14.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol Cell_501_Delegate:class{
//    func notLoginThanToLogin()
    func toProductDetail(_ productId: Int?)
}
// 单品推荐
class Cell_501_Recommend: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 501
    }
    weak var delegate:Cell_501_Delegate?
    
    @IBOutlet weak var imgMain: UIImageView!// 图片
    
    @IBOutlet weak var lbTitle: UILabel!// 主标题
    @IBOutlet weak var lbDes: UILabel!// 简介
    @IBOutlet weak var priceLabel: UILabel!// 现价
    @IBOutlet weak var originalpriceLabel: UILabel!// 原价 当大于现价 显示
    @IBOutlet weak var likeBtn: UIButton!// 收藏按钮
    var productModel : WowModulePageItemVO?
    var productId: Int?// 记录当前产品ID
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        
        if !WOWUserManager.loginStatus {
            UIApplication.currentViewController()?.toLoginVC(true)
        }else{
            
            WOWClickLikeAction.requestFavoriteProduct(productId: productId ?? 0,view: self,btn: sender, isFavorite: {[weak self](isFavorite) in
                
                if let strongSelf = self {
                        print("请求成功")
                    strongSelf.likeBtn.isSelected = isFavorite!
                    self?.productModel?.favorite = isFavorite!
                }
                
            })
        }

        
    }
    func showData(_ p:WowModulePageItemVO) {
        self.productModel = p
        productId = p.productId
        imgMain.isUserInteractionEnabled = true
        if let imageName = p.productImg{
            imgMain.set_webimage_url(imageName)
        }
        
        imgMain.addTapGesture {[weak self] (tap) in// 代理跳转详情
            if let strongSelf = self {
                if let del = strongSelf.delegate {

                    del.toProductDetail(p.productId)
                }
            }
        }
        lbTitle.text                = p.productName
        lbDes.text                  = p.detailDescription
        lbDes.textColor             = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
        /// 如果原价大于售价显示原价并加下划线，如果没有原价或是等于售价不显示
        if let price = p.sellPrice {
            if let originalPrice = p.originalPrice {
                if originalPrice > price{
                    originalpriceLabel.isHidden = false
                    originalpriceLabel.setStrokeWithText(p.get_formted_original_price())
                }else {
                    originalpriceLabel.isHidden = true
                    originalpriceLabel.text = ""
                    
                }
            }else {
                originalpriceLabel.isHidden = true
                originalpriceLabel.text = ""
                
            }
        }
        priceLabel.text         = p.get_formted_sell_price()
        likeBtn.isSelected      = p.favorite ?? false

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
