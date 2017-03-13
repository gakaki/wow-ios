//
//  WOWSearchChildController.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit


enum ShowTypeIndex:String {
    case New            = "onShelfTime" // 当前在上新
    case Sales          = "sales"       // 当前在销量
    case Price          = "price"       // 当前在价格
}
enum SortType:String {
    
    case Asc            = "asc"     // 升序
    case Desc           = "desc"    // 降序
    
}

class WOWSearchChildController: WOWBaseProductsController{
  

    var seoKey: String?
    var couponId: Int?
    

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
        
         var params              = [String: Any]()
         params = ["sort": currentTypeIndex.rawValue  ,"currentPage": pageIndex,"pageSize":currentPageSize,"order":currentSortType.rawValue,"keyword":seoKey ?? ""]
        
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

        WOWNetManager.sharedManager.requestWithTarget(.api_SearchResult(params : params as [String : AnyObject]), successClosure: { [weak self](result, code) in
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
                if ( strongSelf.pageIndex == 1 && strongSelf.dataArr.count > 0){
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
 
    
    func verticalOffsetForEmptyDataSet(_ scrollView: UIScrollView!) -> CGFloat {
        return -40
    }

    
}

