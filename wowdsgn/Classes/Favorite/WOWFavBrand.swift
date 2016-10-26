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
    fileprivate func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.delegate = self
        collectionView.dataSource = self 
        collectionView.register(UINib.nibName(String(describing: WOWFavoriteBrandCell.self)), forCellWithReuseIdentifier:"WOWFavoriteBrandCell")
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
    }
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource   
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: FavoriteEmpty.self), owner: self, options: nil)?.last as! FavoriteEmpty
        
//        view.goStoreButton.addTarget(self, action:#selector(goStore), forControlEvents:.TouchUpInside)
        
        return view
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    //MARK:Action
    func goStore() -> Void {
        print("去逛逛")
    }
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
    }   

    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeBrand, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let brandList = Mapper<WOWBrandListModel>().mapArray(JSONObject:JSON(result)["favoriteBrandVoList"].arrayObject)
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWFavoriteBrandCell.self), for: indexPath) as! WOWFavoriteBrandCell
        let model = dataArr[(indexPath as NSIndexPath).row]
//        cell.logoImg.kf_setImageWithURL(NSURL(string:model.brandLogoImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        
        cell.logoImg.set_webimage_url(model.brandLogoImg)

        
        WOWBorderColor(cell.logoImg)
        cell.logoImg.borderRadius(32)
        cell.logoName.text = model.brandCName ?? ""
        cell.logoDes.text = model.brandDesc ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
        vc.brandID = model.brandId
        vc.entrance = .brandEntrance
        vc.hideNavigationBar = true
        parentNavigationController?.pushViewController(vc, animated: true)
        
    }
}
extension WOWFavBrand:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWFavoriteBrandCell.itemWidth,height: WOWFavoriteBrandCell.itemWidth)
    }
}
