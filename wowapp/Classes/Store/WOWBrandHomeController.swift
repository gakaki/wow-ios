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
    
    var dataArr = [WOWProductModel]()
    var brandID : Int?
    var brandModel : WOWBrandV1Model?
    var designerId : Int?
    var designerModel : WOWDesignerModel?
    
    var entrance = brandOrDesignerEntrance.brandEntrance
    
    private var shareBrandImage:UIImage? //供分享使用
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
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

    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = .None
        configCollectionView()
        collectionView.mj_header = self.mj_header
    }
    
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
//        WOWBorderColor(collectionView)

        collectionView.registerNib(UINib.nibName(String(WOWBrandHeaderView)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    

    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func favoriteButton(sender: UIButton) {
        
    }
    
//MARK:Network
    override func request() {
        super.request()
        //判断一下是品牌详情还是设计师详情
        switch entrance {
        case .brandEntrance:
            requestBrandDetail()
        case .designerEntrance:
            requestDesignerDetail()
        
        }
    }
    
    //品牌详情
    func requestBrandDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_BrandDetail(brandId: brandID ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.brandModel = Mapper<WOWBrandV1Model>().map(result)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ProductBrand(brandId: brandID ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.dataArr = Mapper<WOWProductModel>().mapArray(JSON(result)["productVoList"].arrayObject) ?? [WOWProductModel]()
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    //设计师详情
    func requestDesignerDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_DesignerDetail(designerId: designerId ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.designerModel = Mapper<WOWDesignerModel>().map(result)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_productDesigner(designerId: designerId ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.dataArr = Mapper<WOWProductModel>().mapArray(JSON(result)["productVoList"].arrayObject) ?? [WOWProductModel]()
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    //用户是否喜欢某品牌
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_IsFavoriteProduct(productId: brandID ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.selected = favorite ?? false
            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个品牌
    func requestFavoriteProduct()  {
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId: brandID ?? 0), successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.likeButton.selected = !strongSelf.likeButton.selected
            }
        }) { (errorMsg) in
            
            
        }
    }
    
}


extension WOWBrandHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[indexPath.row]
        cell.showData(model, indexPath: indexPath)

        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? WOWBrandHeaderView
            if let view = headerView {
                //品牌详情
                if let brandModel = brandModel {
                    view.showBrandData(brandModel)
                }
                
                //设计师详情
                if let designerModel = designerModel {
                    view.showDesignerData(designerModel)
                }
                
                view.delegate = self
                
                reusableView = view
            }
        }
        return reusableView!
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        let model = dataArr[indexPath.row]
        vc.hideNavigationBar = true
        vc.productId = model.productId ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWBrandHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)
    }
}

extension WOWBrandHomeController: brandHeaderViewDelegate {
    func moreClick() {
        print("更多")
    }
}
//extension WOWBrandHomeController:WOWActionDelegate{
//    func itemAction(tag: Int) {
//        switch tag {
//        case WOWItemActionType.Like.rawValue:
//            DLog("喜欢")
//        case WOWItemActionType.Share.rawValue:
//            WOWShareManager.share(brandModel?.name, shareText:brandModel?.desc, url:brandModel?.url,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
//        case WOWItemActionType.Brand.rawValue:
//            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandDetailController)) as! WOWBrandDetailController
//            vc.brandModel = brandModel!
//            vc.modalTransitionStyle = .CrossDissolve
//            presentViewController(vc, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//}
