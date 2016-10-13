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
    func goToVC(_ m:WOWModelVoTopic)
    // 点击CollentcionView－Item代理
    func goToProdectDetailVC(_ productId: Int?)
    
    //刷新主页数据 有一个情况，当上面的collectionView 中的产品与下面的tableView的产品为同一个产品， 喜欢上面的，让下面的实时刷新
//    func reloadBottomTableViewData()
    
  }
class WOWHomeFormCell: UITableViewCell {
    
    var scrollViewOffsetDic = Dictionary<Int, CGFloat>() //空字典
    
    weak var delegate : WOWHomeFormDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbMainTitle: UILabel!
    
    @IBOutlet weak var lbContent: UILabel!
    var modelData : WOWModelVoTopic?
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
            collectionView.setContentOffset(CGPoint(x: self.scrollViewOffsetDic[collectionView.tag] ?? 0, y: 0), animated: false)
        }
    }
    lazy var xzm_footer:XZMRefreshNormalFooter = {
        let f = XZMRefreshNormalFooter()
        f.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
        f.pullToRefreshText = "查\n看\n更\n多"
        f.refreshingText = "释\n放\n查\n看"
        f.releaseToRefreshText = "释\n放\n查\n看"
        f.xzm_width = 1
        return f
    }()
    
    func loadMore()  {
        
            self.delegate?.goToVC(modelData!)
            self.endRefresh()

    }
    func endRefresh() {
        
        xzm_footer.endRefreshing()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetSeparators()
        
        
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headIdenString)
        
        collectionView.xzm_footer = self.xzm_footer
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    

    func refreshData(_ sender: Notification)  {
        guard (sender.object != nil) else{//
            return
        }

        for a in 0..<dataArr!.count{
                let model = dataArr![a]
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
      
            
        
        }
        collectionView.reloadData()
        

    
}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension WOWHomeFormCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        if let m = model{
            cell.showData(m, indexPath: indexPath)
            cell.topView.isHidden = true
            cell.view_rightline.isHidden = true
            cell.bottomLine.isHidden = true
        }
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160,height: 246)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let firstIndexPath = IndexPath(item: 0, section: section)
        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: firstIndexPath)
        
        return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                                0, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let del = delegate {
            
            let product = dataArr?[(indexPath as NSIndexPath).row]
            del.goToProdectDetailVC(product?.productId)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 记录当前collectionView的偏移量
        let horizontalOffset = scrollView.contentOffset.x
        
        self.scrollViewOffsetDic[scrollView.tag] = horizontalOffset

    }

}
