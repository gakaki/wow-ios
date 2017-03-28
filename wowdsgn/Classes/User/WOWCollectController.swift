//
//  WOWCollectController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCollectController: WOWBaseViewController {
    
    
    var dataArr  = [WOWProductModel]()
    
    var parentNavigationController : UINavigationController?
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.nibName(String(describing: WOWWorksCell.self)), forCellWithReuseIdentifier:String(describing: WOWWorksCell.self))
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
    }
    
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: FavoriteEmpty.self), owner: self, options: nil)?.last as! FavoriteEmpty
        
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    
    
    
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeProduct, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                
                WOWHud.dismiss()
                let productList = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["favoriteProductVoList"].arrayObject)
                if let productList = productList{
                    strongSelf.dataArr = productList
                }
                strongSelf.endRefresh()
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
        
        cell.showData(model, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.toVCProduct(product.productId)
        
    }
    
}
//MARK: Delegate
extension WOWCollectController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWWorksCell.itemWidth,height: WOWWorksCell.itemWidth)
    }
}
