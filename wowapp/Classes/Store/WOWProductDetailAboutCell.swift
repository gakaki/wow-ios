//
//  WOWProductDetailAboutCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
@objc protocol  WOWProductDetailAboutCellDelegate: NSObjectProtocol{
    
    
    @objc optional func aboutProduct(_ productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int)
    func selectCollectionIndex(_ productId: Int)

}

class WOWProductDetailAboutCell: UITableViewCell {
    
    var pageIndex = 1 //翻页
    var isRreshing : Bool = false
    let pageSize = 6
    
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
        collectionView.register(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


extension WOWProductDetailAboutCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWGoodsSmallCell", for: indexPath) as! WOWGoodsSmallCell
        //FIX 测试数据
        cell.pictureImageView.image = UIImage(named: "4")
        let model = dataArr?[(indexPath as NSIndexPath).item]
        if let m = model {
            cell.showData(m, indexPath: indexPath)
            cell.view_rightline.isHidden = true
            cell.bottomLine.isHidden = true
//            let url             = m.productImg ?? ""
////            cell.pictureImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder_product"))
//            cell.pictureImageView.set_webimage_url(url)
//            
//            cell.desLabel.text       = m.productName
//            let result = WOWCalPrice.calTotalPrice([m.sellPrice ?? 0],counts:[1])
//            cell.priceLabel.text     = result //千万不用格式化了
//            cell.likeBtn.hidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160,height: 246)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {
            let product = dataArr?[(indexPath as NSIndexPath).row]
            del.selectCollectionIndex(product?.productId ?? 0)

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
            del.aboutProduct!(self, pageIndex: pageIndex, isRreshing: isRreshing, pageSize: pageSize)
        }
    }
    
    
    func endRefresh() {
        xzm_footer.endRefreshing()
        self.isRreshing = false
    }
    

}
