import MJRefresh

class VCCategoryProducts:WOWBaseViewController
{
    var cv:UICollectionView!
    var vo_products         = [WOWProductModel]()

    var query_asc           = 1
    var query_currentPage   = 1
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

    override func setUI()
    {
        super.setUI()
        
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
        
        cv.emptyDataSetSource = self;
        cv.emptyDataSetDelegate = self;
 
        self.view.addSubview(cv)
        
        self.mj_footer.setTitle("", forState: MJRefreshState.Idle)
        self.mj_footer.setTitle("", forState: MJRefreshState.Refreshing)
        self.mj_footer.setTitle("", forState: MJRefreshState.Pulling)
        
//        //为了在autolayout的视图里获得真的宽度 主要是给snapkit用的要先来一次
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
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
                      strongSelf.cv.mj_footer = nil
                  }
                  else{
                      strongSelf.cv.mj_footer = strongSelf.mj_footer
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
    
}