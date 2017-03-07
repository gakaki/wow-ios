import RxSwift
import RxCocoa
import RxDataSources

public enum CategoryEntrance {
    case category
    case scene
    case tag
}

class VCCategoryProducts:WOWBaseProductsController
{
 

    /* 请求params */
    var params              = [String: Any]()
    /* main数据条件 */
    var query_showCount     = 10
    //    var query_sortBy        = 1
    var query_categoryId    = 16
    
    var sceneId             = 1
    
    var entrance        = CategoryEntrance.category


      override func request(){

          super.request()
        
        WOWHud.dismiss()
        switch entrance {
        case .category:
            requestCategory()
        case .scene:
            requestScene()
        case .tag:
            requestTag()
        default:
            break
        }

    }
    
    func requestCategory() {
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
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
        }

    }
    
    func requestScene() {
        params = ["sort": currentTypeIndex.rawValue ,"currentPage": pageIndex,"pageSize":currentPageSize,"order":currentSortType.rawValue,"id":self.sceneId]
        
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_SceneProduct(params : params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
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
            
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
        }

    }
    
    func requestTag() {
        params = ["sort": currentTypeIndex.rawValue ,"currentPage": pageIndex,"pageSize":currentPageSize,"order":currentSortType.rawValue,"id":self.sceneId]
        
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_TagProduct(params : params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
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
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
        }

    }
  
}
