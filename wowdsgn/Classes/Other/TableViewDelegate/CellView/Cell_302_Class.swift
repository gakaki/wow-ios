//
//  Cell_302_Class.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/14.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol Cell_302_Delegate:class{
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(_ m:WowModulePageItemVO?)
}
// 一级分类，固定八个Item 最后一个为more
class Cell_302_Class: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 302
    }
    @IBOutlet weak var heightConstraint: NSLayoutConstraint! // collectionView 的高度
    weak var delegate:Cell_302_Delegate?
    var sizeWidth = 80.w
    @IBOutlet weak var cv: UICollectionView!
       var data        = [WowModulePageItemVO]()
    func setData(_ d:[WowModulePageItemVO]){
        self.data = d
        
        cv.reloadData()

        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cv.delegate                           = self
        cv.dataSource                         = self
        
        cv.register(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self))
        cv.register(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self))
        
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            heightConstraint.constant = 215
            sizeWidth = 75.w
        case .dt_iPhone6_Plus:
            heightConstraint.constant = 271
//            sizeWidth = 75.w
        default:
            break
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_302_Class:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var c  =  self.data.count
        if  c > 6 {
            c  =  c + 1 //没办法啦最后一个是more啦
            return c
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ((indexPath as NSIndexPath).item < 7 ){
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell
            let m               = self.data[(indexPath as NSIndexPath).item]
            cell.setModel(m)
            return cell
        }else{
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        return CGSize.init(width: sizeWidth, height: 105.h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            if (indexPath as NSIndexPath).item < 7 {
                let m = self.data[(indexPath as NSIndexPath).row]
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(m)
            }else{
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(nil) //更多
            }
        }
    }
}

