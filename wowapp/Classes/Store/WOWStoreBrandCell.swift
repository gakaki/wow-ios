//
//  WOWStoreBrandCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol BrandCellDelegate:class{
    func hotBrandCellClick(_ brandModel:WOWBrandListModel)
    func recommenProductCellClick(_ productModel:WOWProductModel)
}

class WOWStoreBrandCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var showBrand : Bool = true //热门品牌和推荐商品都取这两个
    weak var delegate:BrandCellDelegate?
    var brandDataArr = [WOWBrandListModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    var productArr = [WOWProductModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:String(describing: WOWImageCell()))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}


extension WOWStoreBrandCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showBrand {
            return brandDataArr.count
        }else{
            return productArr.count > 9 ? 9 : productArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWImageCell", for: indexPath) as! WOWImageCell
        if showBrand {
            let model = brandDataArr[(indexPath as NSIndexPath).item]
//            cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
            cell.pictureImageView.set_webimage_url(model.brandLogoImg)
            WOWBorderColor(cell)
        }else{
            let model = productArr[(indexPath as NSIndexPath).item]
//            cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
            cell.pictureImageView.set_webimage_url(model.productImg)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.w - 45)/3, height: (self.w - 45)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            if showBrand {
                 del.hotBrandCellClick(brandDataArr[(indexPath as NSIndexPath).row])
            }else{
                del.recommenProductCellClick(productArr[(indexPath as NSIndexPath).row])
            }
        }
    }
}
