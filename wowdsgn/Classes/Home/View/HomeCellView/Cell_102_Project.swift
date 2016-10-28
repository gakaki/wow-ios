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
class Cell_102_Project: UITableViewCell {
    weak var delegate : cell_102_delegate?
    @IBOutlet weak var lbTitle: UILabel!
    var dataArr:[WOWCarouselBanners]?{
        didSet{
            
            collectionView.reloadData()
        }
    }

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
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOW_Cell_102_Item", for: indexPath) as! WOW_Cell_102_Item
        //FIX 测试数据
        let model = dataArr?[indexPath.row]
        cell.showData(model!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300,height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 15,0, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate{
            let model = dataArr?[indexPath.row]
            del.goToProjectDetailVC(model)
            
        }

    }
    
}
