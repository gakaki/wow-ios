//
//  WOWSearchChildController.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
class WOWSearchChildController: WOWBaseViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArr = [WOWProductModel]()
    
    //param
    var pageVc: Int?
    var asc: Int?
    var seoKey: String?
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func request() {
        
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_SearchResult(pageSize: 10, currentPage: pageIndex, sortBy: pageVc ?? 0, asc: asc ?? 0, seoKey: seoKey ?? ""), successClosure: { [weak self](result) in
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self {
                strongSelf.endRefresh()

                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
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
                    strongSelf.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.top)
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
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<dataArr.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = dataArr[a]
            

            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
     
        }
        self.collectionView.reloadData()
    }


    override func setUI(){
        collectionView.collectionViewLayout = self.layout
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
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

