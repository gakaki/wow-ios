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
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
//       NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWRefreshFavoritNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(request), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
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
    
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_LikeDesigner, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                WOWHud.dismiss()
                let designerList = Mapper<WOWFavoriteDesignerModel>().mapArray(JSONObject:JSON(result)["favoriteDesignerVoList"].arrayObject)
                if let designerList = designerList{
                    strongSelf.dataArr = designerList
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWFavoriteBrandCell.self), for: indexPath) as! WOWFavoriteBrandCell
        let model = dataArr[(indexPath as NSIndexPath).row]
//        cell.logoImg.kf_setImageWithURL(NSURL(string:model.designerPhoto ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.logoImg.set_webimage_url(model.designerPhoto)

        
        WOWBorderColor(cell.logoImg)
        cell.logoImg.borderRadius(32)
        cell.logoName.text = model.designerName ?? ""
//        cell.logoDes.text = model.designerDesc ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DLog((indexPath as NSIndexPath).row)
        let model = dataArr[(indexPath as NSIndexPath).row]

        VCRedirect.toDesigner(designerId: model.designerId)
    }
}
extension WOWFavDesigner:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWFavoriteBrandCell.itemWidth,height: WOWFavoriteBrandCell.itemWidth)
    }
}
