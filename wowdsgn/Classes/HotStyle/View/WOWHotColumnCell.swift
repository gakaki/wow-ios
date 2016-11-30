//
//  WOWHotColumnCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol WOWHotColumnDelegate:class {

    func goToArticleListVC(_ columntId: Int?, title: String?)
    
}
//尖叫栏目
class WOWHotColumnCell: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 901
    }
    fileprivate var cellItemSpaceing:CGFloat?
    @IBOutlet weak var heightCollectionViewLayout: NSLayoutConstraint!
    var dataArr:[WOWHomeHot_1001_title]?{
        didSet{
            if (dataArr?.count) ?? 0 <= 4 {

                collectionView.isScrollEnabled = false
            }else {
                collectionView.isScrollEnabled = true
            }
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate : WOWHotColumnDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib.nibName(String(describing: WOWColumnCVCelll.self)), forCellWithReuseIdentifier: "WOWColumnCVCelll")
        
        self.contentView.layoutIfNeeded()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            cellItemSpaceing = 18.w
        case .dt_iPhone6:
            cellItemSpaceing = 27.w
        case .dt_iPhone6_Plus:
            cellItemSpaceing = 27.w + 5
        default:
            cellItemSpaceing = 18.w
        }
//        heightCollectionViewLayout.constant = 80.h

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension WOWHotColumnCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWColumnCVCelll", for: indexPath) as! WOWColumnCVCelll
        //FIX 测试数据
        let model = dataArr?[indexPath.row]
        
        if let m = model {
            cell.showData(m)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60,height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellItemSpaceing ?? 27.w
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, cellItemSpaceing ?? 27.w,
                                0, cellItemSpaceing ?? 27.w)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {
            let model = dataArr?[indexPath.row]
            del.goToArticleListVC(model?.id ?? 0,title: model?.name)
        }
       
    }
    
    
}
