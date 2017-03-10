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
    
    weak var delegate : Cell_107_BrandZoneDelegate?
    
    let itemWidth : CGFloat = (MGScreenWidth - 30 - 20 * 2) / 3
    
    @IBOutlet weak var imgBrandBanner: UIImageView!

    
    var modelData : WOWCarouselBanners! {
        didSet{

            if let banners = modelData?.banners {
                if banners.count > 0 {
                    imgBrandBanner.set_webimage_url(banners[0].bannerImgSrc ?? "")
                    
                }
            }
            if let products = modelData?.products {
                if products.count > 0 {
                    
                    heightConstraint.constant = itemWidth * (136/100)
                    
                }else {
                    heightConstraint.constant = 0
                }

            }else {
                heightConstraint.constant = 0
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
            
            del.goToProductDetailVC_107_BrandZone(productId: model?.productId ?? 0)
        }
    }
    //第一个cell居中显示
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsetsMake(10, 0,0, 0)
//    }
    
}
