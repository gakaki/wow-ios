//
//  WOWProductDetailAttriCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailAttriCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var dataArr:[WOWAttributeModel]?{
        didSet{
            collectionView.reloadData()
            let ret1 = (dataArr?.count ?? 0) / 2
            let ret2 = (dataArr?.count ?? 0) % 2
            let total = ret1 + ret2
            collectionViewHeight.constant = CGFloat(total * 130)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(UINib.nibName(String(WOWAttriCollectionCell)), forCellWithReuseIdentifier:"WOWAttriCollectionCell")

    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func chooseStyleClick(sender: UIButton) {
        DLog("选择规格")
    }
}



extension WOWProductDetailAttriCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWAttriCollectionCell", forIndexPath: indexPath) as! WOWAttriCollectionCell
        let model = dataArr?[indexPath.item]
        cell.attriImageView.image = UIImage(named:model?.attriImage ?? " ")
        cell.nameLabel.text       = model?.title
        cell.valueLabel.text      = model?.value
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((MGScreenWidth-30) / 2 - 8, 130)
    }
    
    
}