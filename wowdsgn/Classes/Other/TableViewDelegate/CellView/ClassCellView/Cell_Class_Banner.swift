//
//  CVTableViewCell.swift
//  RangeSlider-Swift
//
//  Created by 陈旭 on 2017/2/23.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class SectionBannerModel: NSObject {
    var BannerImg : String?
    var isOut :Bool?
    
    init(BannerImg : String ,isOut :Bool) {
        super.init()
        self.BannerImg = BannerImg
        self.isOut = isOut
    }
    

}

protocol Cell_Class_BannerDelegate:class{
    
    func updataTableViewCellHight(section: Int)
    func gotoVCFormLinkType_ClassBanner(model: WOWCarouselBanners)
}
// 105 - 分类可伸缩banner
class Cell_Class_Banner: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 105  //分类banner
    }
    
    var indexPathSection:Int!
    
    
    var itemWidthNumber : CGFloat =  50
        
    var itemHight : CGFloat = 100
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = SectionBannerModel.init(BannerImg: "", isOut: false)
    
    var model_Class     : WOWCarouselBanners?{// 数据源
        didSet{
            
            rate = CGFloat(WOWArrayAddStr.get_img_size(str: model_Class?.background ?? ""))// 拿到图片的宽高比
            bannerHeight   = CGFloat(round(MGScreenWidth * rate) )  // 计算此Item的高度

            self.collectionView.reloadData()
            self.heightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
  
            self.layoutIfNeeded()
        }

    }
    weak var delegate : Cell_Class_BannerDelegate?
  
    var rate:CGFloat = 1.0// 宽高比
    
    
    var bannerHeight : CGFloat = MGScreenWidth * 0.33

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib.nibName("Cell_Item_Class"), forCellWithReuseIdentifier: "Cell_Item_Class")
        collectionView.register(UINib.nibName("Cell_Banner_Class"), forCellWithReuseIdentifier: "Cell_Banner_Class")
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.showsHorizontalScrollIndicator   = false
        
    }
    // 更新Layout 高度的变化
    func updateCollectionViewHight()  {
        
        self.collectionView.reloadData()
        self.heightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.updateConstraintsIfNeeded()
        
        if let del = self.delegate {// 代理刷新组
            del.updataTableViewCellHight(section: indexPathSection)
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension Cell_Class_Banner:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard model_Class?.bannerIsOut == true else {// 返回 0
            
            return 1
        }
        
        return (model_Class?.banners?.count ?? 1) + 1
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        switch indexPath.row {
        case 0:
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell_Banner_Class.self), for: indexPath) as! Cell_Banner_Class
           
            if let imageName = model_Class?.background{
                cell.imgBanner.set_webimage_url(imageName)
            }
                cell.imgBanner.addTapGesture(action: {[weak self] (sender) in// 点击banner图片处理事件 控制展开收起状态
                
                    if let strongSelf = self {
                        if strongSelf.model_Class?.bannerIsOut == false {
                            
                            strongSelf.model_Class?.bannerIsOut = true

                        }else{
                            
                            strongSelf.model_Class?.bannerIsOut = false

                            
                        }
                         strongSelf.updateCollectionViewHight()

                    }
                    
                   
                    
                })


            
            return cell
            
        default:
            
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell_Item_Class.self), for: indexPath) as! Cell_Item_Class
            
           
            if let banners = model_Class?.banners {
                
                cell.lb_BannerName.text = banners[indexPath.row - 1].bannerTitle ?? ""
                
            }
            return cell
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if indexPath.row == 0 {
            return CGSize(width: MGScreenWidth - 30,height: bannerHeight)
        }else {
            return CGSize(width: MGScreenWidth - 30,height: 50)
        }
      
    }
    
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 15,0, 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { // 第一行为banner 处理
            return
        }
        if let banners = model_Class?.banners,let del = delegate {
            
            del.gotoVCFormLinkType_ClassBanner(model: banners[indexPath.row - 1])
    
        }
    }
}
