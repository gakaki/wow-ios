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
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WOWUserManager.loginStatus {
            request()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
         NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
    func loginSuccess() {
        request()
    }
    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginSuccess), name: WOWLoginSuccessNotificationKey, object:nil)
        
    }

    override func setUI() {
        super.setUI()
        configCollectionView()
        
    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return l
    }()
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.registerNib(UINib.nibName(String(WOWFavoritrSingleCell)), forCellWithReuseIdentifier:String(WOWFavoritrSingleCell))
        WOWBorderColor(collectionView)
        
    }
    
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        let view = NSBundle.mainBundle().loadNibNamed(String(FavoriteEmpty), owner: self, options: nil).last as! FavoriteEmpty
        
//        view.goStoreButton.addTarget(self, action:#selector(goStore), forControlEvents:.TouchUpInside)
        
        return view
    }
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    //MARK:Action
    func goStore() -> Void {
        print("去逛逛")
    }
    
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeProduct, successClosure: { [weak self](result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let productList = Mapper<WOWFavoriteProductModel>().mapArray(JSON(result)["favoriteProductVoList"].arrayObject)
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
extension WOWFavProduct:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFavoritrSingleCell), forIndexPath: indexPath) as! WOWFavoritrSingleCell
        let model = dataArr[indexPath.row]
//        cell.imageView.kf_setImageWithURL(NSURL(string: model.productImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.imageView.set_webimage_url(model.productImg)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
//        if  let del = self.delegate {
////            let model = dataArr[indexPath.row]
//            del.goGoodsDetail(1)
//        }
        let product = dataArr[indexPath.row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = product.productId
        parentNavigationController?.pushViewController(vc, animated: true)

       
    }
}
//MARK: Delegate
extension WOWFavProduct:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWFavoritrSingleCell.itemWidth,WOWFavoritrSingleCell.itemWidth)
    }
}


