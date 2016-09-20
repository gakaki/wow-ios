//
//  WOWFavBrand.swift
//  wowapp
//
//  Created by 安永超 on 16/7/27.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit


class WOWFavBrand: WOWBaseViewController {

    var dataArr  = [WOWBrandListModel]()
    var parentNavigationController : UINavigationController?

    var isRefresh: Bool = false

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
//        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWRefreshFavoritNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
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
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.registerNib(UINib.nibName(String(WOWFavoriteBrandCell)), forCellWithReuseIdentifier:"WOWFavoriteBrandCell")
   
        
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
    private func addObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(request), name:WOWRefreshFavoritNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(request), name:WOWLoginSuccessNotificationKey, object:nil)
    }   

    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeBrand, successClosure: { [weak self](result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let brandList = Mapper<WOWBrandListModel>().mapArray(JSON(result)["favoriteBrandVoList"].arrayObject)
                if let brandList = brandList{
                    strongSelf.dataArr = brandList
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
extension WOWFavBrand:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFavoriteBrandCell), forIndexPath: indexPath) as! WOWFavoriteBrandCell
        let model = dataArr[indexPath.row]
//        cell.logoImg.kf_setImageWithURL(NSURL(string:model.brandLogoImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        
        cell.logoImg.set_webimage_url(model.brandLogoImg)

        
        WOWBorderColor(cell.logoImg)
        cell.logoImg.borderRadius(32)
        cell.logoName.text = model.brandCName ?? ""
        cell.logoDes.text = model.brandDesc ?? ""
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = model.brandId
        vc.entrance = .brandEntrance
        vc.hideNavigationBar = true
        parentNavigationController?.pushViewController(vc, animated: true)
        
    }
}
extension WOWFavBrand:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWFavoriteBrandCell.itemWidth,WOWFavoriteBrandCell.itemWidth)
    }
}
