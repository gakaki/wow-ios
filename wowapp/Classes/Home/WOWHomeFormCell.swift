//
//  WOWHomeFormCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol WOWHomeFormDelegate:class {
    func goToVC()
}
class WOWHomeFormCell: UITableViewCell {
    
    var scrollViewOffsetDic = Dictionary<Int, CGFloat>() //空字典
    
    weak var delegate : WOWHomeFormDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let headIdenString = "HomeFormReusableView"
    
    var dataArr:[WOWProductModel]?{
        didSet{
            collectionView.reloadData()
        }
    }
    // 当前那一组 （哪一组下的collectionView）
    var indexPathSection : Int? = 0{
        didSet{
            // 给collectionView 的 tag 值 方便记录不同collectionView 的偏移量
            collectionView.tag = indexPathSection ?? 0
            // 回滚collectionView本应偏移的位置
            collectionView.setContentOffset(CGPointMake(self.scrollViewOffsetDic[collectionView.tag] ?? 0, 0), animated: false)
        }
    }
    lazy var xzm_footer:XZMRefreshNormalFooter = {
        let f = XZMRefreshNormalFooter()
         f.pullingPercent = 0.1
        
        f.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
  
        f.pullToRefreshText = "查\n看\n更\n多\n商\n品"
        f.refreshingText = " "
        f.releaseToRefreshText = " "

        return f
    }()
    
    func loadMore()  {

            self.delegate?.goToVC()
            self.endRefresh()

    }
    func endRefresh() {
        
        xzm_footer.endRefreshing()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetSeparators()
        
        
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headIdenString)
        
        collectionView.xzm_footer = self.xzm_footer
        
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
        
//        let lastIndexPath = NSIndexPath(forItem: itemCount - 1, inSection: section)
//        let lastSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: lastIndexPath)
        
        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                                0, 15)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.mj_offsetX > 810.0 && scrollView.mj_offsetX < 812.0{
            //            print("跳转详情页") // 待处理细致逻辑
        }
        guard scrollView is UICollectionView else{
            
            return
        }
        
        // 记录当前collectionView的偏移量
        let horizontalOffset = scrollView.contentOffset.x
        
        self.scrollViewOffsetDic[scrollView.tag] = horizontalOffset
        
        
    }
    
    
    
}
