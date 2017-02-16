//
//  Cell_106_BrandList.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class Cell_106_BrandList: UITableViewCell {
//    static func isNib() -> Bool { return true }
//    static func cell_type() -> Int {
//        return 106
//    }
    var dataArr = [WOWCarouselBanners]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        collectionView.register(Cell_106_Item.self, forCellWithReuseIdentifier:String(describing: Cell_106_Item.self))
        
        collectionView.register(UINib.nibName(String(describing: Cell_106_Item.self)), forCellWithReuseIdentifier: "Cell_106_Item")
//        self.contentView.layoutIfNeeded()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.reloadData()
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell_106_Item.self), for: indexPath) as! Cell_106_Item
//        let m               = dataArr[(indexPath as NSIndexPath).item]
//        cell.setTwoLine_Model(m)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95,height: 120)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    //第一个cell居中显示
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        return UIEdgeInsetsMake(0, 0,0, 15)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//    
}
