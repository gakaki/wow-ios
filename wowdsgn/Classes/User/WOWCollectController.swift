//
//  WOWCollectController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCollectController: WOWBaseViewController {
    
    
    var dataArr  = [WOWWorksListModel]()
    
    var parentNavigationController : UINavigationController?
    
    let pageSize   = 18
    
    weak var delegate: WOWDidScrollDelegate?
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func setUI() {
        super.setUI()
        configCollectionView()
    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 3
        l.minimumColumnSpacing = 3
        l.minimumInteritemSpacing = 3
        l.sectionInset = UIEdgeInsetsMake(3, 3, 0, 3)
        return l
    }()
    fileprivate func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.mj_footer = self.mj_footer
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.nibName(String(describing: WOWWorksCell.self)), forCellWithReuseIdentifier:String(describing: WOWWorksCell.self))
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
    }
    
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWWorkdEmptyView.self), owner: self, options: nil)?.last as! WOWWorkdEmptyView
        
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    
    
    
    //MARK:Network
    override func request() {
        super.request()
        let startRows = (pageIndex - 1) * pageSize
        let params = ["startRows":startRows,"pageSize":pageSize,"type":2]
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
                
            }
            
        }
    }
    
}
extension WOWCollectController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWWorksCell.self), for: indexPath) as! WOWWorksCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        
        cell.showData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.bingWorksDetails(worksId: product.id ?? 0)
        
    }
    
}
//MARK: Delegate
extension WOWCollectController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWWorksCell.itemWidth,height: WOWWorksCell.itemWidth)
    }
}
