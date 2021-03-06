//
//  WOWBrandHomeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum brandOrDesignerEntrance {
    case brandEntrance
    case designerEntrance
}

class WOWBrandHomeController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var likeButton: UIButton!
    
    var dataArr = [WOWProductModel]()   //产品数组列表
    var brandID : Int?                  //品牌ID
    var brandModel : WOWBrandV1Model?   //品牌model
    var designerId : Int?               //设计师ID
    var designerModel : WOWDesignerModel?   //设计师model
    var labelHeight : CGFloat?          //简介高度
    let pageSize = 10                   //分页数据大小
    let nomarlHeight: CGFloat = 355       //默认高度
    
    public var entrance = brandOrDesignerEntrance.brandEntrance     //入口

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        addObserver()
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        l.headerHeight = 355
        return l
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch entrance {
        case .brandEntrance:
            MobClick.e(.Brands_Detail_Page)
            
        case .designerEntrance:
            MobClick.e(.Designers_Detail_Page)
            
        }
    }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = UIRectEdge()
        configCollectionView()
        
        //判断一下是品牌详情还是设计师详情
        switch entrance {
        case .brandEntrance:
            self.title = "品牌主页"
            requestBrandDetail()
            if WOWUserManager.loginStatus {
                requestIsFavoriteBrand()
            }
            
        case .designerEntrance:
            self.title = "设计师主页"

            requestDesignerDetail()
            if WOWUserManager.loginStatus {
                requestIsFavoriteDesigner()
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    func refreshData(_ sender: Notification)  {

        if  let send_obj =  sender.object as? [String:AnyObject] {
            dataArr.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in
                if let strongSelf = self {
                    strongSelf.collectionView.reloadData()
                }
                
            })

        }

     
    }
    
    //初始化产品列表
    func configCollectionView(){
        collectionView.mj_header = self.mj_header
        collectionView.mj_footer = self.mj_footer
        collectionView.collectionViewLayout = self.layout
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))

        collectionView.register(UINib.nibName(String(describing: WOWBrandHeaderView.self)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }

    
    //MARK:Actions
    @IBAction func back(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        switch entrance {
        case .brandEntrance:
          WOWClickLikeAction.requestFavoriteBrand(brandId:brandID ?? 0 , view: self.view, btn: sender, isFavorite: { (isFavorite) in
    
                sender.isSelected = isFavorite ?? false

          })
            
        case .designerEntrance:
            WOWClickLikeAction.requestFavoriteDesigner(designerId:designerId ?? 0 , view: self.view, btn: sender, isFavorite: { (isFavorite) in
                
                sender.isSelected = isFavorite ?? false
                
            })
           
            
        }

    }
    //分享
    @IBAction func shareButton(_ sender: UIButton) {
        switch entrance {
        case .brandEntrance:
            
            let shareUrl = WOWShareUrl + "/brand/\(brandID ?? 0)"
            WOWShareManager.share(brandModel?.brandEname, shareText: brandModel?.desc ?? WowShareText, url:shareUrl,shareImage:brandModel?.image ?? UIImage(named: "me_logo")!)
        case .designerEntrance:
            
            let shareUrl = WOWShareUrl + "/designer/\(designerId ?? 0)"
            WOWShareManager.share(designerModel?.designerName, shareText: designerModel?.designerDesc ?? WowShareText, url:shareUrl,shareImage:designerModel?.designerPhoto ?? UIImage(named: "me_logo")!)
            
        }

    }
    
//MARK:Network
    override func request() {
        super.request()
        //判断一下是品牌详情还是设计师详情
        switch entrance {
        case .brandEntrance:
            requestProductBrand()
            
        case .designerEntrance:
            requestProductDesigner()
            
        }

    }
    
    //品牌详情
    func requestBrandDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_BrandDetail(brandId: brandID ?? 0), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.brandModel = Mapper<WOWBrandV1Model>().map(JSONObject:result)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                WOWHud.showWarnMsg(errorMsg)
                strongSelf.endRefresh()
            }
        }
        
        
    }
    
    //品牌商品列表
    func requestProductBrand() {
//        var params = [String: AnyObject]?()
        let params = ["brandId": brandID ?? 0, "currentPage": pageIndex,"pageSize":pageSize]
       
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductBrand(params: params as [String : AnyObject]), successClosure: {[weak self](result, code) in
          
                if let strongSelf = self{
                    
                    strongSelf.endRefresh()
                    
                    let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                    
                    if let array = arr{
                        
                        if strongSelf.pageIndex == 1{
                            strongSelf.dataArr = []
                        }
                        strongSelf.dataArr.append(contentsOf: 
                            array)
                        //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                        if array.count < strongSelf.pageSize {
                            strongSelf.collectionView.mj_footer = nil
                            
                        }else {
                            strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                        }
                        
                    }else {
                        if strongSelf.pageIndex == 1{
                            strongSelf.dataArr = []
                        }
                    
                        strongSelf.collectionView.mj_footer = nil
                        
                    }
                    strongSelf.collectionView.reloadData()

            }
            
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
            }
        }
    }
    //设计师详情
    func requestDesignerDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_DesignerDetail(designerId: designerId ?? 0), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.designerModel = Mapper<WOWDesignerModel>().map(JSONObject:result)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
            }
        }
        
       
    }
    //设计师商品列表
    func requestProductDesigner() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_productDesigner(designerId: designerId ?? 0, pageSize: pageSize, currentPage: pageIndex), successClosure: {[weak self](result, code) in
            
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.collectionView.mj_footer = nil
                        
                    }else {
                        strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    
                    strongSelf.collectionView.mj_footer = nil
                    
                }
                strongSelf.collectionView.reloadData()
                
            }

        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
            }
        }
    }
    //用户是否喜欢某品牌
    func requestIsFavoriteBrand() {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteBrand(brandId: brandID ?? 0), successClosure: {[weak self] (result, code) in
            
            
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
            }
            
            
            
        }) {(errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }
        
    }
    

    //用户是否喜欢某设计师
    func requestIsFavoriteDesigner() {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteDesigner(designerId: designerId ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
      

            }
        }) {(errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }
        
    }
   
    
}


extension WOWBrandHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell.self), for: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        cell.showData(model, indexPath: indexPath)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WOWBrandHeaderView
            if let view = headerView {
                //品牌详情
                if let brandModel = brandModel {
                    view.showBrandData(model: brandModel)
                }
                
                //设计师详情
                if let designerModel = designerModel {
                    view.showDesignerData(model: designerModel)
                }
                labelHeight = view.brandDescLabel.getEstimatedHeight()
                
                view.delegate = self
                
                reusableView = view
            }
        }
        return reusableView!
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.toVCProduct(model.productId)
        
    }
}



extension WOWBrandHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
}

extension WOWBrandHomeController: brandHeaderViewDelegate {
    func moreClick(_ sender: UIButton!) {
        if sender.isSelected {
            layout.headerHeight = Float(nomarlHeight)
            
        }else {
            layout.headerHeight = Float(nomarlHeight) + Float(labelHeight ?? 0) - 75

        }
        
        if labelHeight == 0 {
            layout.headerHeight = Float(nomarlHeight) - 75
        }
        self.collectionView.reloadData()
        sender.isSelected = !sender.isSelected
        
    }
}

    


