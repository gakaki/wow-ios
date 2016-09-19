//
//  WOWGoodsSmallCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol WOWGoodsSmallCellDelegate: class {
    func likeClick(productId: Int)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
        
    }
    
    func set_sold_out_status(){
        self.label_soldout.hidden = false
//        self.pictureImageView.alpha = 0.4
    }
//    @IBAction func favoriteAction(sender: AnyObject) {
//
//       
//    }

    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        let i = indexPath.item
        if ( i % 2 != 0 && i != 0){
            view_rightline.hidden = true
        }else{
            view_rightline.hidden = false
        }
        productId = model.productId
        
//        pictureImageView.set_webimage_url(model.productImg ?? "")
        // 修改来回上下加载 内存不减的问题
        pictureImageView.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        desLabel.text = model.productName ?? ""
        desLabel.setLineHeightAndLineBreak(1.5)
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
                likeBtn.selected = true
            
            }else{
                likeBtn.selected = false
       
            }
        }else{
            
            likeBtn.selected = false
    
        }
        
        likeBtn.addTarget(self, action: #selector(likeClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    func likeClick(sender: UIButton)  {
        if !WOWUserManager.loginStatus {
            UIApplication.currentViewController()?.toLoginVC(true)
        }else{

            WOWClickLikeAction.requestFavoriteProduct(productId ?? 0, isFavorite: { [weak self](isFavorite) in
                if let strongSelf = self{
                    
                      strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
                }
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
