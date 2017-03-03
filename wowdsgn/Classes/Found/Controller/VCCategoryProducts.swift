import RxSwift
import RxCocoa
import RxDataSources



class VCCategoryProducts:WOWBaseProductsController
{
 

    /* 请求params */
    var params              = [String: Any]()
    /* main数据条件 */
    var query_showCount     = 10
    //    var query_sortBy        = 1
    var query_categoryId    = 16
    
       let ob_content_offset   = Variable(CGFloat(0))
    let rx_disposeBag       = DisposeBag()


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
                
                  DLog(strongSelf.dataArr.count)
                
                  //若是为第一页那么数据直接赋值
                  if ( strongSelf.pageIndex <= 1){
                      strongSelf.dataArr         = data.flatMap { $0 }
    
                  }else{
                      //分页的话数据合并
                      strongSelf.dataArr         = [strongSelf.dataArr, data].flatMap { $0 }
                  }
    
                //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                if data.count < currentPageSize {
                    strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    
                }else {
                    strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                }
                  strongSelf.collectionView.reloadData()
                
                if ( strongSelf.pageIndex == 1 ){
                    if strongSelf.dataArr.count > 0 {
                        strongSelf.collectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.top)
                    }
                }
              }
    
            
          }){[weak self] (errorMsg) in
              if let strongSelf = self {
                  strongSelf.endRefresh()
              }
          }
    
    }
    
  
}
