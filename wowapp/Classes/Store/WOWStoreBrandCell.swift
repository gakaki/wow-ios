//
//  WOWStoreBrandCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol BrandCellDelegate:class{
    func hotBrandCellClick(brandModel:WOWBrandListModel)
    func recommenProductCellClick(productModel:WOWProductModel)
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
        collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}


extension WOWStoreBrandCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showBrand {
            return brandDataArr.count
        }else{
            return productArr.count > 9 ? 9 : productArr.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        if showBrand {
            let model = brandDataArr[indexPath.item]
            let url = NSURL(string:model.brandLogoImg ?? "")
            cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
            WOWBorderColor(cell)
        }else{
            let model = productArr[indexPath.item]
            let url = NSURL(string:model.productImage ?? "")
            cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.w - 45)/3, (self.w - 45)/3)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            if showBrand {
                 del.hotBrandCellClick(brandDataArr[indexPath.row])
            }else{
                del.recommenProductCellClick(productArr[indexPath.row])
            }
        }
    }
}
