//
//  WOWSubArtCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
protocol WOWSubAlertDelegate:class{
    func subAlertItemClick()
}

class WOWSubArtCell: UITableViewCell {
    let imageScale:CGFloat = 1.4
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:WOWSubAlertDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension WOWSubArtCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        //FIXME:替换掉图片
        cell.pictureImageView.image = UIImage(named: "test2")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if  let del = self.delegate {
            del.subAlertItemClick()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(MGScreenWidth * 3 / 8 - 10,MGScreenWidth * 3 / 8 - 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 0, 15)
    }
    
}

