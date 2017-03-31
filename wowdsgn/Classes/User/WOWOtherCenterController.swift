//
//  WOWOtherCenterController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/29.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOtherCenterController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var endUserId:  Int = 0
    var userModel: WOWStatisticsModel?
    var dataArr  = [WOWWorksListModel]()
    
    let pageSize   = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserInfo()
        request()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 3
        l.minimumColumnSpacing = 3
        l.minimumInteritemSpacing = 3
        l.sectionInset = UIEdgeInsetsMake(3, 3, 0, 3)
        l.headerHeight = 233
        return l
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
          }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = UIRectEdge()
        configCollectionView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化产品列表
    func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.mj_footer = self.mj_footer
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.nibName(String(describing: WOWWorksCell.self)), forCellWithReuseIdentifier:String(describing: WOWWorksCell.self))
//        collectionView.emptyDataSetDelegate = self
//        collectionView.emptyDataSetSource = self
        
        collectionView.register(UINib.nibName(String(describing: WOWOtherHeaderView.self)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    

    
 
    
    //MARK:Network
    override func request() {
        super.request()
        let startRows = (pageIndex - 1) * pageSize
        let params = ["startRows":startRows,"pageSize":pageSize,"type":3, "endUserId": endUserId]
        WOWNetManager.sharedManager.requestWithTarget(.api_WorksList(params: params as [String : AnyObject]), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWWorksListModel>().mapArray(JSONObject:JSON(result)["list"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
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
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
                //网络不好，或者请求失败的时候不要+1
                if strongSelf.pageIndex > 1 {
                    strongSelf.pageIndex -= 1
                }
            }
            
        }

    }
    
    func requestUserInfo() {
        let param = ["endUserId": endUserId]
        WOWNetManager.sharedManager.requestWithTarget(.api_UserStatistics(params: param as [String : AnyObject]), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let model = Mapper<WOWStatisticsModel>().map(JSONObject:result)
                strongSelf.userModel = model
                strongSelf.collectionView.reloadData()
            }
            
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

    }
    
}


extension WOWOtherCenterController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWWorksCell.self), for: indexPath) as! WOWWorksCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        
        cell.showData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WOWOtherHeaderView
            if let view = headerView {
               view.configUserInfo(model: userModel)
                reusableView = view
            }
        }
        return reusableView!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.bingWorksDetails(worksId: product.id ?? 0)
    }
}



extension WOWOtherCenterController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWWorksCell.itemWidth,height: WOWWorksCell.itemWidth)
    }
}


