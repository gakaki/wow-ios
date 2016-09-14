//
//  WOWHomeFormCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol WOWHomeFormDelegate:class {
    // 右滑进入更多商品代理
    func goToVC()
    // 点击CollentcionView－Item代理
    func goToProdectDetailVC(productId: Int?)
    
    //刷新主页数据 有一个情况，当上面的collectionView 中的产品与下面的tableView的产品为同一个产品， 喜欢上面的，让下面的实时刷新
    func reloadBottomTableViewData()
    
  }
class WOWHomeFormCell: UITableViewCell {
    
    var scrollViewOffsetDic = Dictionary<Int, CGFloat>() //空字典
    
    weak var delegate : WOWHomeFormDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbMainTitle: UILabel!
    
    @IBOutlet weak var lbContent: UILabel!
    
    let headIdenString = "HomeFormReusableView"
    
//    var mainModel : WOWModelVoTopic   {
//    
//        didSet{
//        
//        }
//    }
    
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
//         f.pullingPercent = 0.1
        
        f.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
  
        f.pullToRefreshText = "查\n看\n更\n多\n商\n品"
        f.refreshingText = " "
        f.releaseToRefreshText = " "
        f.beginRefreshingCallback = {
            print("进入刷新")
        }
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
        
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(refreshData), name:WOWRefreshFavoritNotificationKey, object:nil)
        
    }
    

    func refreshData(sender: NSNotification)  {
    
        for a in 0..<dataArr!.count{
                let model = dataArr![a]
            
                if model.productId! == sender.object!["productId"] as! Int {
                model.favorite = sender.object!["favorite"] as? Bool
            }
        
        }
        collectionView.reloadData()

    
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
                return dataArr?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
        //FIX 测试数据
        cell.pictureImageView.image = UIImage(named: "4")
        let model = dataArr?[indexPath.item]
        if let m = model{
            cell.showData(m, indexPath: indexPath)
//            cell.likeBtn.tag = m.productId!
//            cell.likeBtn.addTarget(self, action: #selector(WOWHomeFormCell.favorite(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    
        return cell
    }
//    func favorite(sender: UIButton) {
//        
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:sender.tag ?? 0), successClosure: { [weak self](result) in
//            if let strongSelf = self{
//                
////                let favorite = JSON(result)["favorite"].bool
////                sender.selected = favorite ?? false // 在这注释掉，是因为会多闪一下
//                
//                strongSelf.delegate?.reloadBottomTableViewData()
//                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
//            }
//        }) { (errorMsg) in
//            
//            
//        }
//
//    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    //第一个cell居中显示
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        let firstIndexPath = NSIndexPath(forItem: 0, inSection: section)
        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: firstIndexPath)
        
        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                                0, 15)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let del = delegate {
            
            let product = dataArr?[indexPath.row]
            del.goToProdectDetailVC(product?.productId)
            
        }
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
