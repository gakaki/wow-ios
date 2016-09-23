//
//  WOWSubArtCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
@objc protocol WOWSubAlertDelegate:class{
    func subAlertItemClick(_ productID:Int)
}

class WOWSubArtCell: UITableViewCell {
    let imageScale:CGFloat = 1.4
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:WOWSubAlertDelegate?
    
    var dataArr : [WOWProductModel]?{
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

extension WOWSubArtCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWImageCell", for: indexPath) as! WOWImageCell
        let model = dataArr?[(indexPath as NSIndexPath).row]
//        cell.pictureImageView.kf_setImageWithURL(NSURL(string:model?.productImg ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        
        cell.pictureImageView.set_webimage_url( model?.productImg )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let del = self.delegate {
            let model = dataArr?[(indexPath as NSIndexPath).row]
            del.subAlertItemClick(model?.productId ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.w * 3 / 8 - 10,height: self.w * 3 / 8 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 0, 15)
    }
    
}

