//
//  WowSenceLikeCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
class WOWSenceLikeCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreLikeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension WOWSenceLikeCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWImageCell), forIndexPath: indexPath) as! WOWImageCell
        //FIXME:测试
        cell.pictureImageView.image = UIImage(named: "testHeadImage")
        cell.pictureImageView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(30,30)
    }
    
    
}
