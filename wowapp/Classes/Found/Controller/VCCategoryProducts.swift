
import UIKit

class VCCategoryProducts:UIViewController ,CollectionViewWaterfallLayoutDelegate
{
    var cv:UICollectionView!
    var vo_products                         = [WOWProductModel]()
//    
//    func reset_fetch_params(){
//        self.pageIndex = 1
//        if ( self.cv_bottom != nil ){
//            self.cv_bottom.setContentOffset(CGPointZero, animated: true)
//            
//        }
//    }
    
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
    
    override  func viewDidLoad() {
        request()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI()
    {
        cv = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        cv.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "10")!)
        
        //为了在autolayout的视图里获得真的宽度 主要是给snapkit用的要先来一次
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        edgesForExtendedLayout = .None
        
        
//        cv.mj_footer = self.mj_footer
//        cv.mj_footer.setTitle("", forState: MJRefreshState.Idle)
    }
    
    
    
    func request(){
//          // 1 上方collectionview 触发 , 2 中间选择 tab 触发 3 下方下拉查看触发
//          //{"asc":1,"currentPage":1,"showCount":10,"sortBy":1,"categoryId":16}
//          WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Product_By_Category(asc: self.query_asc, currentPage: self.pageIndex, showCount: self.query_showCount, sortBy: self.query_sortBy, categoryId: self.cid.toInt()! ), successClosure: {[weak self] (result) in
//              if let strongSelf = self {
//                  strongSelf.endRefresh()
//    
//                  let res                   = JSON(result)
//                  let data                  = Mapper<WOWProductModel>().mapArray(res["productVoList"].arrayObject) ?? [WOWProductModel]()
//                  DLog(strongSelf.vo_products.count)
//    
//                  if ( data.count <= 0 || data.count < strongSelf.query_showCount){
//                      strongSelf.cv_bottom.mj_footer = nil
//                  }
//                  else{
//                      strongSelf.cv_bottom.mj_footer = strongSelf.mj_footer
//    
//                  }
//    
//                  //若是为第一页那么数据直接赋值
//                  if ( strongSelf.pageIndex <= 1){
//                      strongSelf.vo_products         = data.flatMap { $0 }
//    
//                  }else{
//                      //分页的话数据合并
//                      strongSelf.vo_products         = [strongSelf.vo_products, data].flatMap { $0 }
//                  }
//    
//                  strongSelf.cv_bottom.reloadData()
//              }
//    
//              
//          }){[weak self] (errorMsg) in
//              print(errorMsg)
//              if let strongSelf = self {
//                  strongSelf.endRefresh()
//              }
//              
//          }
    }
    
    private func configCollectionView(){
        
        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.whiteColor()
        cv.backgroundView                   = bg_view
        
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.showsHorizontalScrollIndicator   = false
        cv.showsVerticalScrollIndicator     = false
        
        cv.decelerationRate                 = UIScrollViewDecelerationRateFast
        //        cv_bottom.bounces = false
   
//        cv.emptyDataSetSource = self;
//        cv.emptyDataSetDelegate = self;
    }

}

extension VCCategoryProducts:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
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