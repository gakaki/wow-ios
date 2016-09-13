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
    @IBOutlet weak var view_rightline: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
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
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        priceLabel.text     = result//千万不用格式化了
        
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
        requestFavoriteProduct(productId ?? 0)
    }
    
    //用户喜欢某个单品
    func requestFavoriteProduct(productId: Int)  {
        WOWHud.showLoadingSV()

        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:productId), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
//            if let strongSelf = self{
//                strongSelf.likeBtn.selected = !strongSelf.likeBtn.selected
                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
            }
        }) { (errorMsg) in
            
            
        }
    }
    
    
}
