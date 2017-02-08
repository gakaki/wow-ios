import RxSwift
import RxCocoa
import RxDataSources


protocol VCCategoryProductsDelegate :class{
    func cvTopView(isHidden: Bool)
}
class VCCategoryProducts:WOWBaseViewController,UIScrollViewDelegate
{
    var cv:UICollectionView!
    var vo_products         = [WOWProductModel]()
    weak var delegate: VCCategoryProductsDelegate?

    /* 请求params */
    var params              = [String: Any]()
    /* main数据条件 */
    var query_showCount     = 10
    //    var query_sortBy        = 1
    var query_categoryId    = 16
    var currentTypeIndex:ShowTypeIndex   = .New
    var currentSortType :SortType        = .Asc
    
    var query_sortBy        = 1{
        didSet{
            if query_sortBy == 1 {
                currentTypeIndex = .New
            }
            if query_sortBy == 2 {
                currentTypeIndex = .Sales
            }
            if query_sortBy == 3 {
                currentTypeIndex = .Price
            }
            
        }
    }
    var query_asc          = 1{
        didSet{
            if query_asc == 1 {
                currentSortType = .Asc
            }
            if query_asc == 0 {
                currentSortType = .Desc
            }
        }
    }
    
    /* 筛选条件 */
    var screenColorArr     : [String]?
    var screenStyleArr     : [String]?
    var screenPriceArr     = Dictionary<String, Int>()
    var screenScreenArr    : [String]?
    var screenMinPrice     : Int?
    var screenMaxPrice     : Int?
    
    var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        return l
    }()

    init(){
        super.init(nibName: nil, bundle: nil)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
//    func is_load_more(_ y:CGFloat) -> Bool
//    {
//        
//        let contentSize  = self.cv.contentSize.height
//        let view_height  = self.view.frame.size.height * 1.5
//        var is_load_more = false
//        if ( y > contentSize - view_height ) && ( contentSize - view_height > 0 ) {
//            is_load_more = true
//        }else{
//            is_load_more = false
//        }
//        
//        //        print( "conteoff  y  : ", y )
//        //        print( "view_height  : ", view_height )
//        //        print( "contentSize  : ", contentSize )
//        //        print( "is_load_more : ", is_load_more )
//        //        print( "contentSize - view_height : ", contentSize - view_height )
//        
//        return is_load_more
//    }
    
    override func setUI()
    {
        super.setUI()
        addObserver()
        edgesForExtendedLayout = UIRectEdge()
        

        
        let frame = CGRect(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight - 215)
        cv = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        cv.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))

        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.white
        cv.backgroundView                   = bg_view
        
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.showsHorizontalScrollIndicator   = false
        cv.showsVerticalScrollIndicator     = false
        
        cv.decelerationRate                 = UIScrollViewDecelerationRateFast
        //cv.bounces = false
        cv.mj_header = self.mj_header
        cv.mj_footer = self.mj_footer

        cv.emptyDataSetSource               = self;
        cv.emptyDataSetDelegate             = self;
//        view.insertSubview(cv, belowSubview: screenBtnimg)
        view.addSubview(cv)
        cv.snp.makeConstraints { [weak self](make) in
              if let strongSelf = self {
            make.width.equalTo(MGScreenWidth)
//            make.top.equalTo(0)
                make.right.equalTo(strongSelf.view).offset(0)
            make.top.bottom.equalTo(strongSelf.view).offset(0)
            }
        }
//        configScreeningView()
//        self.mj_footer.setTitle("", forState: MJRefreshState.Idle)
//        self.mj_footer.setTitle("", forState: MJRefreshState.Refreshing)
//        self.mj_footer.setTitle("", forState: MJRefreshState.Pulling)
        
//        //为了在autolayout的视图里获得真的宽度 主要是给snapkit用的要先来一次
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
        
//        self.pageIndex = 0
//        self.ob_content_offset.asObservable()
//            .map { $0 }
//            .map { y in
//                return self.is_load_more(y)
//            }
//            .distinctUntilChanged()
//            .subscribe { [unowned self] in
//                self.title = "contentOffset.y = \($0)"
//
////                if $0 == true {
//                    self.pageIndex = self.pageIndex + 1
////                    self.request()
////                }
//                
//            }
//            .addDisposableTo(rx_disposeBag)
    }
    
    let ob_content_offset   = Variable(CGFloat(0))
    let rx_disposeBag       = DisposeBag()

//    func scrollViewDidScroll( _ scrollView: UIScrollView){
//        ob_content_offset.value = scrollView.contentOffset.y
//    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: NSNotification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<vo_products.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = vo_products[a]
            
            if  let send_obj =  sender.object as? [String:AnyObject] {

                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
        }
        cv.reloadData()
    }
    
//    asc: self.query_asc, currentPage: self.pageIndex, showCount: self.query_showCount, sortBy: self.query_sortBy, categoryId: self.query_categoryId
    override func request(){

          super.request()
        
        WOWHud.dismiss()
        params = ["sort": currentTypeIndex.rawValue ,"currentPage": pageIndex,"pageSize":currentPageSize,"order":currentSortType.rawValue,"categoryId":self.query_categoryId]
        
        if let min = screenMinPrice {
            
            params["minPrice"] = min
            
        }
        if let max = screenMaxPrice {
            
             params["maxPrice"] = max
            
        }
        if screenColorArr?.count > 0 {
            
            params["colorIds"] = screenColorArr
            
        }
        
        if screenStyleArr?.count > 0 {
            
            params["styleIds"] = screenStyleArr
            
        }
        if screenScreenArr?.count > 0 {
            
            params["sceneIds"] = screenScreenArr
            
        }
        print(params)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Product_By_Category(params : params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
                
              if let strongSelf = self {
                  strongSelf.endRefresh()
    
                
                  let res                   = JSON(result)
                  let arr                   = res["products"].arrayObject
                  let data                  = Mapper<WOWProductModel>().mapArray( JSONObject:arr  ) ?? [WOWProductModel]()
                
                  DLog(strongSelf.vo_products.count)
    
//                  if ( data.count <= 0 || data.count < strongSelf.query_showCount){
////                      strongSelf.cv.mj_footer = nil
//                  }
//                  else{
////                      strongSelf.cv.mj_footer = strongSelf.mj_footer
//                  }
                
                  //若是为第一页那么数据直接赋值
                  if ( strongSelf.pageIndex <= 1){
                      strongSelf.vo_products         = data.flatMap { $0 }
    
                  }else{
                      //分页的话数据合并
                      strongSelf.vo_products         = [strongSelf.vo_products, data].flatMap { $0 }
                  }
    
                //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                if data.count < currentPageSize {
                    strongSelf.cv.mj_footer.endRefreshingWithNoMoreData()
                    
                }else {
                    strongSelf.cv.mj_footer = strongSelf.mj_footer
                }
                  strongSelf.cv.reloadData()
              }
    
               if ( self?.pageIndex == 1 ){
                    if self!.vo_products.count > 0 {
                        self!.cv.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.top)
                    }
                }
          }){[weak self] (errorMsg) in
              if let strongSelf = self {
                  strongSelf.endRefresh()
              }
          }
    }
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWEmptySearchView.self), owner: self, options: nil)?.last as! WOWEmptySearchView

        return view
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
//    func verticalOffsetForEmptyDataSet(_ scrollView: UIScrollView!) -> CGFloat {
//        return -40
//    }


}

extension VCCategoryProducts:UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width:WOWGoodsSmallCell.itemWidth, height:WOWGoodsSmallCell.itemWidth + 75)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vo_products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell.self), for: indexPath) as! WOWGoodsSmallCell
            let model = vo_products[indexPath.row]
            cell.showData(model, indexPath: indexPath)
            //            cell.set_sold_out_status()
            return cell
            
    }
    
    //选中时的操作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let model = vo_products[indexPath.row]
         VCRedirect.toVCProduct(model.productId)
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard vo_products.count > 4 else {
            return
        }
        let offsetY = scrollView.contentOffset.y
        var isHidden = false
        if offsetY > 100 {
            isHidden = true
        }
        if  let del = delegate {
            del.cvTopView(isHidden: isHidden)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if  let del = delegate {
            del.cvTopView(isHidden: false)
        }
    }
}
