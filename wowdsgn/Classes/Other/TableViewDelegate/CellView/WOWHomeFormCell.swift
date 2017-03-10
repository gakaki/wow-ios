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
class WOWHomeFormCell: UITableViewCell,ModuleViewElement {
    
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 601 //  专题商品列表
    }
    var scrollViewOffsetDic = Dictionary<Int, CGFloat>() //空字典
    
    weak var delegate : WOWHomeFormDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbMainTitle: UILabel!
    
    var heightAll:CGFloat = 430
    
    @IBOutlet weak var lbContent: UILabel!
    var modelData : WOWModelVoTopic?{
        didSet{
            lbMainTitle.text = modelData?.topicName
            lbContent.text   = modelData?.topicDesc
            lbContent.setLineHeightAndLineBreak(1.5)
            dataArr          = modelData?.products
        }
    }

    let headIdenString = "HomeFormReusableView"
    var numberCell     = 0
    var dataArr:[WOWProductModel]?{
        didSet{
            collectionView.reloadData()
            numberCell = (dataArr?.count ?? 0) > 6 ? 6 : (dataArr?.count ?? 0) + 1
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
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            f.xzm_width = 14
        case.dt_iPhone6:
            f.xzm_width = 1
        case.dt_iPhone6_Plus:
            f.xzm_width = 1
        default:
            f.xzm_width = 14
        }
        return f
    }()
    
    func loadMore()  {
        if let modelData = modelData  {
            self.delegate?.goToVC(modelData)
        }
    
        self.endRefresh()

    }
    func endRefresh() {
        
        xzm_footer.endRefreshing()
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetSeparators()
        
        
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        collectionView.register(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self))
        
        self.contentView.layoutIfNeeded()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    

    func refreshData(_ sender: Notification)  {

        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            dataArr?.ergodicArrayWithProductModel(dic: send_obj)
            collectionView.reloadData()
        }
    
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
        return numberCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == numberCell - 1 {
            
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell
   
            cell.setLookMoreUI()
            return cell
        }else {
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
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160,height: 246)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        
        return UIEdgeInsetsMake(0, 25,
                                0, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == numberCell - 1 { // 点击更多进入分类页面
            if let del = delegate {
                if let modelData = modelData {
                    del.goToVC(modelData)

                }
            }

        }else {
            if let del = delegate {
                
                let product = dataArr?[(indexPath as NSIndexPath).row]
                del.goToProdectDetailVC(product?.productId)
                
            }

        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 记录当前collectionView的偏移量
        let horizontalOffset = scrollView.contentOffset.x
        
        self.scrollViewOffsetDic[scrollView.tag] = horizontalOffset

    }

}
