//
//  WOWGoodsSmallCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol WOWGoodsSmallCellDelegate: class {
    func likeClick(_ productId: Int)
}

class WOWGoodsSmallCell: UICollectionViewCell {
     class var itemWidth:CGFloat{
        get{
           return ( MGScreenWidth - 0.5) / 2
        }
    }
    
    weak var delegate: WOWGoodsSmallCellDelegate?
    var productId :Int?
    @IBOutlet weak var label_soldout: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originalpriceLabel: UILabel!
    @IBOutlet weak var view_rightline: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var lbLabel: UILabel!// 冬日促销标签
    @IBOutlet weak var lbDiscount: UILabel!// 折扣标签
    @IBOutlet weak var lbNew: UILabel!// 新品标签
    @IBOutlet weak var LeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
        
    }
    
    func set_sold_out_status(){
        label_soldout.borderRadius(28)
        self.label_soldout.isHidden = false

    }
    func showData(_ model:WOWProductModel,indexPath:IndexPath) {
        if model.productStock == 0 {// 以售馨展示
            
            set_sold_out_status()
            
        }else {
           label_soldout.isHidden = true
        }
        let i = (indexPath as NSIndexPath).item
        if ( i % 2 != 0 && i != 0){
            view_rightline.isHidden = true
        }else{
            view_rightline.isHidden = false
        }
        if i > 1 {
            topView.isHidden = true
        }else {
            topView.isHidden = false
        }
        productId = model.productId
        
        
        
//        let img_url            = "\(model.productImg ?? "")?imageView2/0/w/400/format/webp/q/85"
//        let url_obj            = URL(string:model.productImg?.webp_url())
        let image_place_holder = UIImage(named: "placeholder_product")
        pictureImageView.set_webimage_url(model.productImg)
//        pictureImageView.yy_setImage(with: url_obj, placeholder: image_place_holder)
        
        // 修改来回上下加载 内存不减的问题
        desLabel.text = model.productTitle ?? ""
        if let price = model.sellPrice {
            let result = WOWCalPrice.calTotalPrice([price],counts:[1])
            priceLabel.text     = result//千万不用格式化了            
            if let originalPrice = model.originalprice,model.originalprice > price{

                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    originalpriceLabel.setStrokeWithText(result)

            }else {
                originalpriceLabel.setStrokeWithText("")
            }
        }

        if WOWUserManager.loginStatus {
            if (model.favorite == true) {
                likeBtn.isSelected = true
            
            }else{
                likeBtn.isSelected = false
       
            }
        }else{
            
            likeBtn.isSelected = false
    
        }
        
        likeBtn.addTarget(self, action: #selector(likeClick(_:)), for: .touchUpInside)
        self.isHiddenSignsLabel(model: model)
    }
    func isHiddenSignsLabel(model:WOWProductModel)  {
        lbNew.isHidden              = true
        lbDiscount.isHidden         = true
        lbLabel.isHidden            = true

        if let discount = model.discount {
            lbDiscount.isHidden  = false
            lbDiscount.text      = (discount + "折").get_formted_Space()
        }else {
            lbDiscount.isHidden = true
            lbDiscount.text = ""
        }
        for singModel in model.sings ?? []{
            switch singModel.id ?? 0{
            case 4:
                
                lbLabel.isHidden  = false
                lbLabel.text      = singModel.desc?.get_formted_Space()
            case 3:
                lbNew.isHidden = false
            case 2:
                lbDiscount.isHidden = false
                lbDiscount.text     = ((singModel.desc ?? "") + "折").get_formted_Space()
            default: break
            }
        }
        if lbDiscount.isHidden && !lbLabel.isHidden{
          
            self.LeftConstraint.constant = 0
           
        }else {
            LeftConstraint.constant = 5
        }
    }

    func likeClick(_ sender: UIButton)  {
        if !WOWUserManager.loginStatus {
            UIApplication.currentViewController()?.toLoginVC(true)
        }else{

            WOWClickLikeAction.requestFavoriteProduct(productId: productId ?? 0,view: viewBottom,btn: sender, isFavorite: {(isFavorite) in
                //                if let strongSelf = self{
                print("请求成功")
                //                      strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
                //                }

            })
        }
        
    }
    
}
