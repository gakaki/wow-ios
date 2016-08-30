//
//  WOWHomeFormCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHomeFormCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
      let headIdenString = "HomeFormReusableView"
    var dataArr:[WOWProductModel]?{
        didSet{
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
         self.resetSeparators()
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        
         collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headIdenString)
//        collectionView.contentOffset = CGPointMake(0, 0)
//        collectionView.setContentOffset(CGPointMake(0, 0), animated: false)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension WOWHomeFormCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return dataArr?.count ?? 0
        return 5
    }
//    //返回HeadView的宽高
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//        
//        return CGSize(width: zj_width, height: 50.h)
//    }
//    
//    //返回自定义HeadView或者FootView，我这里以headview为例
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
//        var headView = UICollectionReusableView()
//        if kind == UICollectionElementKindSectionHeader
//        {
//            headView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headIdenString, forIndexPath: indexPath)
////            headView.backgroundColor = UIColor.redColor()
//            
//            
//        }
//        return headView
//    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
        //FIX 测试数据
        cell.pictureImageView.image = UIImage(named: "4")
        let model = dataArr?[indexPath.item]
        if let m = model {
            let url             = m.productImg ?? ""
            //            cell.pictureImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder_product"))
            cell.pictureImageView.set_webimage_url(url)
            
            cell.desLabel.text       = m.productName
            let result = WOWCalPrice.calTotalPrice([m.sellPrice ?? 0],counts:[1])
            cell.priceLabel.text     = result //千万不用格式化了
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    //第一个和最后一个cell居中显示
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: section)
        
        let firstIndexPath = NSIndexPath(forItem: 0, inSection: section)
        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: firstIndexPath)
        
        let lastIndexPath = NSIndexPath(forItem: itemCount - 1, inSection: section)
        let lastSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: lastIndexPath)
        
        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                                0, (collectionView.bounds.size.width - lastSize.width) / 2)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
       
        if scrollView.mj_offsetX > 810.0 && scrollView.mj_offsetX < 812.0{
            print("跳转详情页") // 待处理细致逻辑
        }
    }

    
}
