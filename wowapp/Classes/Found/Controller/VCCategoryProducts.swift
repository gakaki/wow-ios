import RxSwift
import RxCocoa
import RxDataSources

class VCCategoryProducts:WOWBaseViewController,UIScrollViewDelegate
{
    var cv:UICollectionView!
    var vo_products         = [WOWProductModel]()

    var query_asc           = 1
    var query_showCount     = 30
    var query_sortBy        = 1
    var query_categoryId    = 16
    
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

    
    
    func is_load_more(y:CGFloat) -> Bool
    {
        
        let contentSize  = self.cv.contentSize.height
        let view_height  = self.view.frame.size.height * 1.5
        var is_load_more = false
        if ( y > contentSize - view_height ) && ( contentSize - view_height > 0 ) {
            is_load_more = true
        }else{
            is_load_more = false
        }
        
        //        print( "conteoff  y  : ", y )
        //        print( "view_height  : ", view_height )
        //        print( "contentSize  : ", contentSize )
        //        print( "is_load_more : ", is_load_more )
        //        print( "contentSize - view_height : ", contentSize - view_height )
        
        return is_load_more
    }
    
    override func setUI()
    {
        super.setUI()
        addObserver()
        edgesForExtendedLayout = .None
        
        let frame = CGRectMake(0,0, MGScreenWidth, MGScreenHeight - 210)
        cv = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        cv.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))

        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.whiteColor()
        cv.backgroundView                   = bg_view
        
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.showsHorizontalScrollIndicator   = false
        cv.showsVerticalScrollIndicator     = false
        
        cv.decelerationRate                 = UIScrollViewDecelerationRateFast
        //cv.bounces = false
        
        cv.emptyDataSetSource               = self;
        cv.emptyDataSetDelegate             = self;
 
        view.addSubview(cv)
        
//        self.mj_footer.setTitle("", forState: MJRefreshState.Idle)
//        self.mj_footer.setTitle("", forState: MJRefreshState.Refreshing)
//        self.mj_footer.setTitle("", forState: MJRefreshState.Pulling)
        
//        //为了在autolayout的视图里获得真的宽度 主要是给snapkit用的要先来一次
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
        
        self.pageIndex = 0
        self.ob_content_offset.asObservable()
            .map { $0 }
            .map { y in
                return self.is_load_more(y)
            }
            .distinctUntilChanged()
            .subscribeNext { [unowned self] in
                self.title = "contentOffset.y = \($0)"

                if $0 == true {
                    self.pageIndex = self.pageIndex + 1
                    self.request()
                }
                
            }
            .addDisposableTo(rx_disposeBag)
    }
    
    let ob_content_offset   = Variable(CGFloat(0))
    let rx_disposeBag       = DisposeBag()

    func scrollViewDidScroll( scrollView: UIScrollView){
        ob_content_offset.value = scrollView.contentOffset.y
    }
    private func addObserver(){
        /**
         添加通知
         */
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(refreshData), name:WOWRefreshFavoritNotificationKey, object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(sender: NSNotification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<vo_products.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = vo_products[a]
            
            if model.productId! == sender.object!["productId"] as? Int {
                model.favorite = sender.object!["favorite"] as? Bool
                
                break
            }
        }
        cv.reloadData()
    }

    override func request(){

          super.request()
        
          WOWHud.dismiss()

          WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Product_By_Category(
            asc: self.query_asc, currentPage: self.pageIndex, showCount: self.query_showCount, sortBy: self.query_sortBy, categoryId: self.query_categoryId ), successClosure: {[weak self] (result) in
                
              if let strongSelf = self {
                  strongSelf.endRefresh()
    
                  let res                   = JSON(result)
                  let data                  = Mapper<WOWProductModel>().mapArray(res["productVoList"].arrayObject) ?? [WOWProductModel]()
                  DLog(strongSelf.vo_products.count)
    
                  if ( data.count <= 0 || data.count < strongSelf.query_showCount){
//                      strongSelf.cv.mj_footer = nil
                  }
                  else{
//                      strongSelf.cv.mj_footer = strongSelf.mj_footer
                  }
    
                  //若是为第一页那么数据直接赋值
                  if ( strongSelf.pageIndex <= 1){
                      strongSelf.vo_products         = data.flatMap { $0 }
    
                  }else{
                      //分页的话数据合并
                      strongSelf.vo_products         = [strongSelf.vo_products, data].flatMap { $0 }
                  }
    
                
                  strongSelf.cv.reloadData()
              }
    
               if ( self?.pageIndex == 1 ){
                    if self!.vo_products.count > 0 {
                        self!.cv.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Top)
                    }
                }
          }){[weak self] (errorMsg) in
              if let strongSelf = self {
                  strongSelf.endRefresh()
              }
          }
    }
    


}

extension VCCategoryProducts:UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
      return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vo_products.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
            let model = vo_products[indexPath.row]
            cell.showData(model, indexPath: indexPath)
            //            cell.set_sold_out_status()
            return cell
            
    }
    
    //选中时的操作
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
         let model = vo_products[indexPath.row]
         toVCProduct(model.productId)
    }

    
}