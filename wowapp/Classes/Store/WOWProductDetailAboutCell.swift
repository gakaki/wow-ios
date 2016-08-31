//
//  WOWProductDetailAboutCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol  WOWProductDetailAboutCellDelegate: class{
    func requestAboutProduct(productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int)
}

class WOWProductDetailAboutCell: UITableViewCell {
    
    var pageIndex = 1 //翻页
    var isRreshing : Bool = false
    let pageSize = 10
    
    weak var delegate: WOWProductDetailAboutCellDelegate?
    //MARK: ->  params
    var brandId: Int?
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr:[WOWProductModel]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))
        return f
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        

    }
    
    func showData()  {
        if let del = delegate {
            del.requestAboutProduct(self, pageIndex: pageIndex, isRreshing: isRreshing, pageSize: pageSize)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


extension WOWProductDetailAboutCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0

    }
    
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
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        let itemCount = self.collectionView(collectionView, numberOfItemsInSection: section)
//        
//        let firstIndexPath = NSIndexPath(forItem: 0, inSection: section)
//        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: firstIndexPath)
//        
//        let lastIndexPath = NSIndexPath(forItem: itemCount - 1, inSection: section)
//        let lastSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: lastIndexPath)
//        
//        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
//                                0, (collectionView.bounds.size.width - lastSize.width) / 2)
//    }

}

extension WOWProductDetailAboutCell {
    
    //MARK:Private Method
    
    func loadMore() {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        if let del = delegate {
            del.requestAboutProduct(self, pageIndex: pageIndex, isRreshing: isRreshing, pageSize: pageSize)
        }
    }
    
    
    func endRefresh() {
        mj_footer.endRefreshing()
        self.isRreshing = false
    }
    

}
