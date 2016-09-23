//
//  WOWFavProduct.swift
//  wowapp
//
//  Created by 安永超 on 16/7/27.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit



class WOWFavProduct: WOWBaseViewController {


    var dataArr  = [WOWFavoriteProductModel]()
    
    var parentNavigationController : UINavigationController?
    
    var isRefresh: Bool = false
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WOWUserManager.loginStatus {
            request()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false

//        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWRefreshFavoritNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    override func setUI() {
        super.setUI()
        configCollectionView()
        addObserver()
    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return l
    }()
    fileprivate func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.register(UINib.nibName(String(describing: WOWFavoritrSingleCell.self)), forCellWithReuseIdentifier:String(WOWFavoritrSingleCell.self))
        WOWBorderColor(collectionView)
        
    }
    
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: FavoriteEmpty()), owner: self, options: nil)?.last as! FavoriteEmpty
        
//        view.goStoreButton.addTarget(self, action:#selector(goStore), forControlEvents:.TouchUpInside)
        
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    //MARK:Action
    func goStore() -> Void {
        DLog("去逛逛")
    }
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
 

    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeProduct, successClosure: { [weak self](result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let productList = Mapper<WOWFavoriteProductModel>().mapArray(JSONObject:JSON(result)["favoriteProductVoList"].arrayObject)
                if let productList = productList{
                    strongSelf.dataArr = productList
                }
                strongSelf.endRefresh()
                strongSelf.isRefresh = true
                strongSelf.collectionView.reloadData()

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()

            }

        }
    }
    
}
extension WOWFavProduct:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWFavoritrSingleCell()), for: indexPath) as! WOWFavoritrSingleCell
        let model = dataArr[(indexPath as NSIndexPath).row]
//        cell.imageView.kf_setImageWithURL(NSURL(string: model.productImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.imageView.set_webimage_url(model.productImg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = dataArr[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = product.productId
        parentNavigationController?.pushViewController(vc, animated: true)

       
    }
}
//MARK: Delegate
extension WOWFavProduct:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWFavoritrSingleCell.itemWidth,height: WOWFavoritrSingleCell.itemWidth)
    }
}


