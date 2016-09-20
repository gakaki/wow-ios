//
//  WOWFavDesigner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/27.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit



class WOWFavDesigner: WOWBaseViewController {
    
    
    var dataArr  = [WOWFavoriteDesignerModel]()
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
//       NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWRefreshFavoritNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    private func addObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(request), name:WOWRefreshFavoritNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(request), name:WOWLoginSuccessNotificationKey, object:nil)
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
    
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeDesigner, successClosure: { [weak self](result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let designerList = Mapper<WOWFavoriteDesignerModel>().mapArray(JSON(result)["favoriteDesignerVoList"].arrayObject)
                if let designerList = designerList{
                    strongSelf.dataArr = designerList
                }
                strongSelf.collectionView.reloadData()
                strongSelf.isRefresh = true
                strongSelf.endRefresh()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
                
            }
        }
    }
}
extension WOWFavDesigner:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFavoriteBrandCell), forIndexPath: indexPath) as! WOWFavoriteBrandCell
        let model = dataArr[indexPath.row]
//        cell.logoImg.kf_setImageWithURL(NSURL(string:model.designerPhoto ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.logoImg.set_webimage_url(model.designerPhoto)

        
        WOWBorderColor(cell.logoImg)
        cell.logoImg.borderRadius(32)
        cell.logoName.text = model.designerName ?? ""
        cell.logoDes.text = model.designerDesc ?? ""
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        DLog(indexPath.row)
        let model = dataArr[indexPath.row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.designerId = model.designerId
        vc.entrance = .designerEntrance
        vc.hideNavigationBar = true
        parentNavigationController?.pushViewController(vc, animated: true)

    }
}
extension WOWFavDesigner:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWFavoriteBrandCell.itemWidth,WOWFavoriteBrandCell.itemWidth)
    }
}