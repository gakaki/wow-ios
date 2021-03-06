//
//  Cell_106_BrandList.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
protocol Cell_106_BrandListDelegate:class{
    
    func goToVCFormLinkType_106_Banner(model: WOWCarouselBanners)
    
}
// 热门分类
class Cell_106_BrandList: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 106
    }
    var itemBottomHeight:CGFloat        = 0.0 // collectionView 距底部 当有“查看更多为0”否“为10”
    weak var delegate : Cell_106_BrandListDelegate?
    var dataArr = [WOWCarouselBanners](){
        didSet{
            if dataArr.count > 0 {
                
//                rate = CGFloat(WOWArrayAddStr.get_img_size(str: dataArr[0].bannerImgSrc ?? ""))// 拿到图片的宽高比
                
                itemHeight = WOWArrayAddStr.get_img_sizeNew(str: dataArr[0].bannerImgSrc ?? "", width: itemWidth, defaule_size: .OneToOne)
//                itemHeight   = CGFloat(round(itemWidth * rate) )  // 计算此Item的高度
                heightConstraint.constant = itemHeight + itemBottomHeight
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
//    var rate:CGFloat = 1.0// 宽高比
    
    var moduleId: Int! = 0
    var pageTitle: String! = ""
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var itemHeight : CGFloat = MGScreenWidth * 0.33
    let itemWidth : CGFloat = (MGScreenWidth - 30 - 10 * 2) / 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib.nibName(String(describing: Cell_106_Item.self)), forCellWithReuseIdentifier: "Cell_106_Item")
        collectionView.delegate = self
        collectionView.dataSource = self
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_106_BrandList:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count > 3 ? 3 : dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell_106_Item.self), for: indexPath) as! Cell_106_Item
        let m               = dataArr[indexPath.row]

        if let imageName = m.bannerImgSrc{
            cell.imgBanner.set_webimage_url(imageName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth,height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0,itemBottomHeight, 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {// 点击banner 跳转
             let model = dataArr[indexPath.row]
            //Mob 热门分类模块 banner点击
            let bannerId = String(format: "%i_%@_%i", moduleId, pageTitle, model.id ?? 0)
            let bannerName = String(format: "%i_%@_%@", moduleId, pageTitle, model.bannerTitle ?? "")
            let bannerPosition = String(format: "%i_%@_%i", moduleId, pageTitle, indexPath.row)
            let params = ["ModuleID_Secondary_Homepagename_Bannersid": bannerId, "ModuleID_Secondary_Homepagename_Bannersname": bannerName, "ModuleID_Secondary_Homepagename_Bannersposition": bannerPosition]
            MobClick.e2(.Hot_Category_Clicks, params)

            del.goToVCFormLinkType_106_Banner(model: model)
        }
    }
  
}
