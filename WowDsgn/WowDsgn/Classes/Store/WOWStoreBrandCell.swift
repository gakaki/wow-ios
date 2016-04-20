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
}

class WOWStoreBrandCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:BrandCellDelegate?
    var dataArr : [WOWBrandListModel]?{
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
        if let arr = dataArr {
            return arr.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        if let arr = dataArr {
            let model = arr[indexPath.item]
            let url = NSURL(string:model.imageUrl ?? "")
            cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((MGScreenWidth - 45)/3, (MGScreenWidth - 45)/3)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.hotBrandCellClick(dataArr![indexPath.row])
        }
    }
}
