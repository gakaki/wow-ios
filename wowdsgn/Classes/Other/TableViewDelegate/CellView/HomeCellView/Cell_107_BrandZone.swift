//
//  Cell_107_ProjectSelect.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/13.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

protocol Cell_107_BrandZoneDelegate:class{
    // banner 跳转
    func goToVCFormLinkType_107_BrandZone(model: WOWCarouselBanners)
    // 跳转产品详情代理
    func goToProductDetailVC_107_BrandZone(productId: Int?)
}

// 品牌专区  一个推荐banner + 底部三个商品
class Cell_107_BrandZone: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 107  //品牌专区  一个推荐banner + 底部三个商品
    }
    var moduleId: Int! = 0
    var pageTitle: String! = ""
    weak var delegate : Cell_107_BrandZoneDelegate?
    
    let itemWidth : CGFloat = (MGScreenWidth - 30 - 20 * 2) / 3
    
    @IBOutlet weak var imgBrandBanner: UIImageView!

    var itemBottomHeight:CGFloat        = 0.0 // collectionView 距底部 当有“查看更多为0”否“为10”
    var modelData : WOWCarouselBanners! {
        didSet{

            if let banners = modelData?.banners {
                if banners.count > 0 {
                    
                    imgHeightConstraint.constant   = WOWArrayAddStr.get_img_sizeNew(str: banners[0].bannerImgSrc ?? "", width: MGScreenWidth - 30 , defaule_size: .ThreeToTwo)
                    
                    imgBrandBanner.set_webimage_url(banners[0].bannerImgSrc ?? "")
                    
                }
            }
            if let products = modelData?.products {
                if products.count > 0 {
                    
                    heightConstraint.constant = itemWidth * (136/100) + itemBottomHeight
                    
                }else {
                    heightConstraint.constant = itemBottomHeight
                }

            }else {
                heightConstraint.constant = itemBottomHeight
            }

            collectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgTopBanner: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib.nibName("Cell_107_Item"), forCellWithReuseIdentifier: "Cell_107_Item")
//        collectionView.register(UINib.nibName("Cell_Banner_Class"), forCellWithReuseIdentifier: "Cell_Banner_Class")
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.showsHorizontalScrollIndicator   = false
        
        imgBrandBanner.addTapGesture {[weak self] (sender) in // 大图点击事件  banner 跳转
            if let strongSelf = self {
                if let del = strongSelf.delegate,let banners = strongSelf.modelData?.banners{
                    
                    if banners.count > 0 {
                        //Mob 品牌专区模块 banner点击
                        let bannerId = String(format: "%i_%@_%i", strongSelf.moduleId, strongSelf.pageTitle, banners[0].id ?? 0)
                        let bannerName = String(format: "%i_%@_%@", strongSelf.moduleId, strongSelf.pageTitle, banners[0].bannerTitle ?? "")
                        let params = ["ModuleID_Secondary_Homepagename_Brandid": bannerId, "ModuleID_Secondary_Homepagename_Brandname": bannerName]
                        MobClick.e2(.Brand_Module_Clicks, params)
                        
                        del.goToVCFormLinkType_107_BrandZone(model: banners[0])
                            
                    }
                    
                }
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_107_BrandZone:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let product = modelData?.products {
            return product.count > 3 ? 3 : product.count
        }else {
            return 0
        }
       

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell_107_Item.self), for: indexPath) as! Cell_107_Item
        
        cell.model = modelData.products?[indexPath.row]
        
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       return CGSize(width: itemWidth,height: itemWidth * (136/100))
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {// 点击跳转商品详情
            let model = modelData.products?[indexPath.row]
            //Mob 品牌专区模块 product点击
            let productId = String(format: "%i_%@_%i", moduleId, pageTitle, model?.productId ?? 0)
            let productName = String(format: "%i_%@_%@", moduleId, pageTitle, model?.productName ?? "")
            let productPosition = String(format: "%i_%@_%i", moduleId, pageTitle, indexPath.row)
            let params = ["ModuleID_Secondary_Homepagename_Productid": productId, "ModuleID_Secondary_Homepagename_Productname": productName, "ModuleID_Secondary_Homepagename_Productposition": productPosition]
            MobClick.e2(.Brand_Module_Clicks, params)

            del.goToProductDetailVC_107_BrandZone(productId: model?.productId ?? 0)
        }
    }
    //第一个cell居中显示
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsetsMake(10, 0,0, 0)
//    }
    
}
