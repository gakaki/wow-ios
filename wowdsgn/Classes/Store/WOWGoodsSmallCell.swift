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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
        
    }
    
    func set_sold_out_status(){
        self.label_soldout.isHidden = false
//        self.pictureImageView.alpha = 0.4
    }
//    @IBAction func favoriteAction(sender: AnyObject) {
//
//       
//    }

    func showData(_ model:WOWProductModel,indexPath:IndexPath) {
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
        
//        pictureImageView.set_webimage_url(model.productImg ?? "")
        // 修改来回上下加载 内存不减的问题
        pictureImageView.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        desLabel.text = model.productName ?? ""
//        desLabel.setLineHeightAndLineBreak(1.5)
        if let price = model.sellPrice {
            let result = WOWCalPrice.calTotalPrice([price],counts:[1])
            priceLabel.text     = result//千万不用格式化了            
            if let originalPrice = model.originalprice {
                if originalPrice > price{
                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    
                    originalpriceLabel.setStrokeWithText(result)
                }
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
    }
    
    func likeClick(_ sender: UIButton)  {
        if !WOWUserManager.loginStatus {
            UIApplication.currentViewController()?.toLoginVC(true)
        }else{

            WOWClickLikeAction.requestFavoriteProduct(productId: productId ?? 0,view: self.contentView,btn: sender, isFavorite: {(isFavorite) in
                //                if let strongSelf = self{
                print("请求成功")
                //                      strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
                //                }

            })
        }
        
    }
    
//    //用户喜欢某个单品
//    func requestFavoriteProduct(productId: Int)  {
//        WOWHud.showLoadingSV()
//
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:productId), successClosure: {[weak self] (result) in
//            if let strongSelf = self{
//                strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
////            if let strongSelf = self{
////                strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
//                let favorite = JSON(result)["favorite"].bool
//                var params = [String: AnyObject]?()
//                
//                params = ["productId": productId, "favorite": favorite!]
//                
//                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params)
//            }
//        }) { (errorMsg) in
//            
//            
//        }
//    }
    
    
}