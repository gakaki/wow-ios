//
//  WOWBuyCarNormalCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWBuyCarNormalCell: UITableViewCell ,TagCellLayoutDelegate{

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var perPriceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    let identifier = "WOWTagCollectionViewCell"
    var typeArr = Array<String>?()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultSetup()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.selected = selected
    }
    
    func showData(model:WOWBuyCarModel) {
        goodsImageView.kf_setImageWithURL(NSURL(string:model.skuProductImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        nameLabel.text = model.skuProductName
        countLabel.text = "x \(model.skuProductCount)"
        perPriceLabel.text = model.skuProductPrice.priceFormat()
    }
    
    func defaultSetup() {
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: identifier)
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)
        collectionView?.collectionViewLayout = tagCellLayout
        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
    }
    //MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
        return CGFloat(28.0)
    }
    
    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        

            let item = typeArr?[index]
            let title = item ?? ""
            let width = title.size(Fontlevel004).width + 12
            return width
        
    }
    //MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
            cell.textLabel.font = UIFont.systemFontOfSize(10)
            cell.textLabel.textColor = MGRgb(128, g: 128, b: 128)
            if let arr = typeArr {
                let item = arr[indexPath.row]
                cell.textLabel.text = item
            }
        return cell
            
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArr == nil ? 0 : (typeArr?.count)!
    }

 
}
