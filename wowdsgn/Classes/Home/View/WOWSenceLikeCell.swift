
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
    @IBOutlet weak var rightBackView: UIView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    /// 是确认订单界面用到的话，需要将它的尺寸搞大点 其他的都是小一点的
//    var orderTag:Bool = false{
//        didSet{
//            if orderTag {
//                collectionView.reloadData()
//            }
//        }
//    }
    
    var orderArr = [WOWCarProductModel](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:String(describing: WOWImageCell.self))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


extension WOWSenceLikeCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if orderTag {
            return orderArr.count
//        }else{
//            //FIXME:测试数据
//            return 50
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWImageCell.self), for: indexPath) as! WOWImageCell
//        if orderTag {
//            let orderItem = orderArr[(indexPath as NSIndexPath).item]
//            cell.pictureImageView.kf_setImageWithURL(NSURL(string:orderItem.skuProductImageUrl)!, placeholderImage: UIImage(named: "placeholder_product"))
//        }
        //FIXME:测试
        cell.pictureImageView.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if orderTag {
//            return CGSizeMake(46,46)
//        }else{
            return CGSize(width: 40, height: 40)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 15, 8, 8)
    }
    
    
}
