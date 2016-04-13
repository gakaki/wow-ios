//
//  WOWStoreBrandCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol BrandCellDelegate:class{
    func hotBrandCellClick()
}

class WOWStoreBrandCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:BrandCellDelegate?
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
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        //FIXME:修改掉
        cell.pictureImageView.image = UIImage(named: "testBrand")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((MGScreenWidth - 45)/3, (MGScreenWidth - 45)/3)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.hotBrandCellClick()
        }
    }
}
