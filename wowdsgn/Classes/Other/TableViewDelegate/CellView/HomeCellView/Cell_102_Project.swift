//
//  Cell_102_Project.swift
//  wowapp
//
//  Created by 陈旭 on 2016/10/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol cell_102_delegate:class {
    // 跳转专题详情代理
    func goToProjectDetailVC(_ model: WOWCarouselBanners?)
}
// 专题 cell
class Cell_102_Project: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 102  //专题
    }
    var heightAll:CGFloat = 290
    weak var delegate : cell_102_delegate?
    var moduleId: Int! = 0
    var pageTitle: String! = ""
    var dataArr:[WOWCarouselBanners]!{
        didSet{
            let lineNumber =  Int(dataArr.count > 3 ? 3 : dataArr.count) // item 最多为三个
            itemAllHeight  =  0.0
            heightSet.removeAll()
            for item in dataArr.enumerated() { // 遍历数组 取对应图片的宽和高
                if item.offset < lineNumber { // 取前三个图片的高度
//                    let rate =  CGFloat(WOWArrayAddStr.get_img_size(str: item.element.bannerImgSrc ?? ""))// 拿到图片的宽高比
//                        let itemHeight1 = CGFloat(round(itemWidth * rate) )
                    let itemHeight = WOWArrayAddStr.get_img_sizeNew(str: item.element.bannerImgSrc ?? "", width: itemWidth, defaule_size: .ThreeToTwo)
                    
//
                    heightSet.append(itemHeight)
                    itemAllHeight = itemAllHeight + itemHeight
                }
            }
            
            
            heightConstraint.constant = itemAllHeight + CGFloat(10 * (lineNumber - 1)) // collectionView 的总高度
            collectionView.reloadData()
        }
    }
    
    var itemWidth:CGFloat       = MGScreenWidth - 30
    
    var itemAllHeight:CGFloat   = 0.0
    
    var heightSet = [CGFloat]()
 
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib.nibName(String(describing: WOW_Cell_102_Item.self)), forCellWithReuseIdentifier: "WOW_Cell_102_Item")
        
        self.contentView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_102_Project:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count > 3 ? 3 : dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOW_Cell_102_Item", for: indexPath) as! WOW_Cell_102_Item
        //FIX 测试数据
        let model = dataArr?[indexPath.row]
        if let model = model {
            cell.showData(model)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if let heightSet = heightSet {
        if  heightSet.count > indexPath.row {
            return CGSize(width: itemWidth ,height: heightSet[indexPath.row])

//        }
        }else {
            return CGSize(width: itemWidth ,height: 200)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 15,0, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate{
            let model = dataArr?[indexPath.row]
            //Mob 纵向banner模块 banner点击
            let bannerId = String(format: "%i_%@_%i", moduleId, pageTitle, model?.id ?? 0)
            let bannerName = String(format: "%i_%@_%@", moduleId, pageTitle, model?.bannerTitle ?? "")
            let bannerPosition = String(format: "%i_%@_%i", moduleId, pageTitle, indexPath.row)
            let params = ["ModuleID_Secondary_Homepagename_Bannersid": bannerId, "ModuleID_Secondary_Homepagename_Bannersname": bannerName, "ModuleID_Secondary_Homepagename_Bannersposition": bannerPosition]
            MobClick.e2(.Bannerlist_Portrait, params)

            del.goToProjectDetailVC(model)
            
        }

    }
    
}
