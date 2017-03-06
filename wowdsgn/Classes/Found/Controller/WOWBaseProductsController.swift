//
//  WOWBaseProductsController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

protocol WOWBaseProductsControllerDelegate :class{
    func topView(isHidden: Bool)
}

class WOWBaseProductsController: WOWBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var dataArr = [WOWProductModel](){
        didSet {
            self.collectionView.reloadData()
        }
    }
    var currentTypeIndex:ShowTypeIndex  = .New
    var currentSortType:SortType        = .Asc
    //param
    var pageVc: Int?{
        didSet{
            if pageVc == 1 {
                currentTypeIndex = .New
            }
            if pageVc == 2 {
                currentTypeIndex = .Sales
            }
            if pageVc == 3 {
                currentTypeIndex = .Price
            }
            
        }
    }
    var asc: Int? {
        didSet{
            if asc == 1 {
                currentSortType = .Asc
            }
            if asc == 0 {
                currentSortType = .Desc
            }
        }
    }
    
    /* 筛选条件 */
    var screenColorArr     : [String]?
    var screenStyleArr     : [String]?
    var screenPriceArr     = Dictionary<String, Int>()
    var screenScreenArr    : [String]?
    var screenMinPrice      : Int?
    var screenMaxPrice      : Int?
    
    weak var delegate: WOWBaseProductsControllerDelegate?
  
    
    /// lazy
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        
        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            dataArr.ergodicArrayWithProductModel(dic: send_obj)
            self.collectionView.reloadData()
        }
        
    }
    
    override func setUI(){
        super.setUI()
        collectionView.collectionViewLayout = self.layout
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
        collectionView.mj_header = self.mj_header
        collectionView.mj_footer = self.mj_footer
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate  = self
        collectionView.emptyDataSetSource    = self
    }
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWEmptySearchView.self), owner: self, options: nil)?.last as! WOWEmptySearchView
        
        return view
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


extension WOWBaseProductsController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell.self), for: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        cell.showData(model, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.toVCProduct(model.productId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard dataArr.count > 4 else {
            return
        }
        let offsetY = scrollView.contentOffset.y
        var isHidden = false
        if offsetY > 100 {
            isHidden = true
        }
        if  let del = delegate {
            del.topView(isHidden: isHidden)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if  let del = delegate {
            del.topView(isHidden: false)
        }
    }
    
    
}


extension WOWBaseProductsController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
}
