//
//  WOWProductDetailAboutCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol  WOWProductDetailAboutCellDelegate: class{
    func aboutProduct(productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int)
    
    func selectCollectionIndex(productId: Int?)
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
    
    
    
    lazy var xzm_footer:XZMRefreshNormalFooter = {
        let f = XZMRefreshNormalFooter()
        f.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
    
        return f
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        collectionView.xzm_footer = self.xzm_footer
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
            cell.likeBtn.hidden = false
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(160,246)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = delegate {
            let product = dataArr?[indexPath.row]
            del.selectCollectionIndex(product?.productId)

        }

    }

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
            del.aboutProduct(self, pageIndex: pageIndex, isRreshing: isRreshing, pageSize: pageSize)
        }
    }
    
    
    func endRefresh() {
        xzm_footer.endRefreshing()
        self.isRreshing = false
    }
    

}
