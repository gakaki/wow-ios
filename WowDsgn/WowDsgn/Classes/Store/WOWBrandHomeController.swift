//
//  WOWBrandHomeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBrandHomeController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    var dataArr = [WOWProductModel]()
    var brandID : String?
    var brandModel : WOWBrandModel?
    private var shareBrandImage:UIImage? //供分享使用
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0.5
        l.minimumInteritemSpacing = 0.5
        l.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1)
        l.headerHeight = Float(MGScreenWidth * 2 / 3)
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
        WOWBorderColor(collectionView)
        collectionView.registerClass(WOWBrandTopView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    

    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_BrandDetail(brandid: brandID ?? ""), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.brandModel = Mapper<WOWBrandModel>().map(result)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
}


extension WOWBrandHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandModel?.products?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
        let model = brandModel?.products?[indexPath.row]
        cell.desLabel.text = model?.productName
        cell.priceLabel.text = model?.price?.priceFormat()
        cell.pictureImageView.kf_setImageWithURL(NSURL(string:model?.productImage ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        switch indexPath.row {
        case 0,1:
            cell.topLine.hidden = false
        default:
            cell.topLine.hidden = true
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? WOWBrandTopView
            if let view = headerView {
                view.topHeadView.delegate = self
                view.underHeadView.delegate = self
                view.topHeadView.headImageView.kf_setImageWithURL(NSURL(string:brandModel?.image ?? "")!, placeholderImage: UIImage(named: "placeholder_product"), optionsInfo: nil, completionHandler: {[weak self](image, error, cacheType, imageURL) in
                    if let strongSelf = self{
                        strongSelf.shareBrandImage = image
                    }
                })
                view.topHeadView.nameLabel.text = brandModel?.name
                reusableView = view
            }
        }
        return reusableView!
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        let model = brandModel?.products?[indexPath.row]
        vc.productID = model?.productID ?? ""
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWBrandHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 65)
    }
}

extension WOWBrandHomeController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            DLog("喜欢")
        case WOWItemActionType.Share.rawValue:
            WOWShareManager.share(brandModel?.name, shareText:brandModel?.desc, url:brandModel?.url,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
        case WOWItemActionType.Brand.rawValue:
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandDetailController)) as! WOWBrandDetailController
            vc.brandModel = brandModel!
            vc.modalTransitionStyle = .CrossDissolve
            presentViewController(vc, animated: true, completion: nil)
        default:
            break
        }
    }
}
