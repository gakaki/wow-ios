//
//  WOWFavDesigner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/27.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit



class WOWFavDesigner: WOWBaseViewController {
    
    
    var dataArr  = [WOWBrandListModel]()
    var parentNavigationController : UINavigationController?

    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configCollectionView()
        
    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0.5
        l.minimumInteritemSpacing = 0.5
        l.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1)
        return l
    }()
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.registerNib(UINib.nibName(String(WOWFavoriteBrandCell)), forCellWithReuseIdentifier:"WOWFavoriteBrandCell")
        
        
    }
    
    
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        let view = NSBundle.mainBundle().loadNibNamed(String(FavoriteEmpty), owner: self, options: nil).last as! FavoriteEmpty
        
        view.goStoreButton.addTarget(self, action:#selector(goStore), forControlEvents:.TouchUpInside)
        
        return view
    }
    
    //MARK:Action
    func goStore() -> Void {
        print("去逛逛")
    }
    
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeBrand, successClosure: { [weak self](result) in
            if let strongSelf = self{
                let brandList = Mapper<WOWBrandListModel>().mapArray(JSON(result)["likedBrandVoList"].arrayObject)
                if let brandList = brandList{
                    strongSelf.dataArr = brandList
                }
                strongSelf.collectionView.reloadData()
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
        cell.logoImg.kf_setImageWithURL(NSURL(string:model.brandImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        //        vc.productID = produtID
        parentNavigationController?.pushViewController(vc, animated: true)
      

    }
}
extension WOWFavDesigner:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWFavoriteBrandCell.itemWidth,WOWFavoriteBrandCell.itemWidth + 63)
    }
}