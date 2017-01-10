//
//  WOWSearchChildController.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
enum productEntrance {
    case searchEntrance
    case couponEntrance
}

enum ShowTypeIndex:String {
    case New            = "score" // 当前在上新
    case Sales          = "sales" // 当前在销量
    case Price          = "price" // 当前在价格
}
enum SortType:String {
    
    case Asc            = "asc"     // 升序
    case Desc           = "desc"    // 降序
    
}
class WOWSearchChildController: BaseScreenViewController{
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
    var seoKey: String?
    var couponId: Int?
    var entrance        = productEntrance.searchEntrance
    
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
    override func request() {
        
        super.request()
        switch entrance {
        case .searchEntrance:
            requestSearch()
        case .couponEntrance:
            requestCoupon()
        default:
            break
        }
    }
    
    func requestSearch()  {
        var params = [String: AnyObject]()
        
   
        params = ["sort": currentTypeIndex.rawValue as AnyObject ,"currentPage": pageIndex as AnyObject,"pageSize":currentPageSize as AnyObject,"order":currentSortType.rawValue as AnyObject,"keyword":seoKey  as AnyObject]
        
//        pageSize: 10, currentPage: pageIndex, sortBy: pageVc ?? 0, asc: asc ?? 0, seoKey: seoKey ?? ""
//            params = ["pageSize": pageSize, "currentPage": currentPage, "sortBy": sortBy, "asc": asc, "seoKey":seoKey]
        WOWNetManager.sharedManager.requestWithTarget(.api_SearchResult(params : params), successClosure: { [weak self](result, code) in
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self {
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["products"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < 10 {
                        strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.collectionView.reloadData()
                if ( strongSelf.pageIndex == 1 ){
                    strongSelf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
                }
            }
            
            
            
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
                
            }
            
        }
    }
    
    func requestCoupon() {
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductsOfCoupon(pageSize: 10, currentPage: pageIndex, sortColumn: pageVc ?? 0, sortType: asc ?? 0, id: couponId ?? 0), successClosure: { [weak self](result, code) in
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self {
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["products"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < 10 {
                        strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.collectionView.reloadData()
                if ( strongSelf.pageIndex == 1 ){
                    if strongSelf.dataArr.count > 0{
                        strongSelf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
                    }
                    
                }
            }
            
            
            
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
                
            }
            
        }
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
    }
    
    
    
}





extension WOWSearchChildController:UICollectionViewDelegate,UICollectionViewDataSource{
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
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        let model = dataArr[(indexPath as NSIndexPath).row]
        vc.hideNavigationBar = true
        vc.productId = model.productId ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWSearchChildController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
}

