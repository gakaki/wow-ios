//
//  Cell_104_TwoLine.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/12/19.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol Cell_104_TwoLineDelegate:class{
    
    func goToProductGroupList(_ groupId:Int)
}

class Cell_104_TwoLine: UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 104
    }
    weak var delegate:Cell_104_TwoLineDelegate?
    var dataArr = [WOWCarouselBanners](){
        didSet{
            
           
            rate = CGFloat(WOWArrayAddStr.get_img_size(str: dataArr[0].bannerImgSrc ?? ""))// 拿到图片的宽高比
            itemHight = itemWidthNumber * rate // 计算此Item的高度
            let lineNumber = dataArr.count.getParityCellNumber() 
            heightConstraint.constant = CGFloat((lineNumber * Int(itemHight)) + 8 * (lineNumber - 1)) // collectionView 的总高度
            
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var heightConstraint: NSLayoutConstraint! // collectionView 的高度
    
    var rate:CGFloat = 1.0// 宽高比
    
    var itemWidthNumber : CGFloat = (MGScreenWidth - (15 * 2) - 8) / 2{
        didSet{
            itemHight = itemWidthNumber * rate
        }
    }
    
    var itemHight : CGFloat = 100
    

    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self))
        
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
extension Cell_104_TwoLine:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell
        let m               = dataArr[(indexPath as NSIndexPath).item]
        cell.setTwoLine_Model(m)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidthNumber,height: itemHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 15,0, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            let m               = dataArr[(indexPath as NSIndexPath).item]
            del.goToProductGroupList(m.bannerLinkTargetId ?? 0)
        }
        
    }
    
}
