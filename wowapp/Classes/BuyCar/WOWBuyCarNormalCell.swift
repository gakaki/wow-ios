//
//  WOWBuyCarNormalCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWBuyCarNormalCell: UITableViewCell ,TagCellLayoutDelegate{

    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCountButton: UIButton!
    @IBOutlet weak var addCountButton: UIButton!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var perPriceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    let identifier = "WOWTagCollectionViewCell"
    var typeArr = Array<String>?()
    var model:WOWCarProductModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultSetup()
    }
    
    func defaultSetup() {
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: identifier)
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)
        collectionView?.collectionViewLayout = tagCellLayout
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(model:WOWCarProductModel?) {
        guard let model = model else{
            return
        }
        self.model = model
        goodsImageView.kf_setImageWithURL(NSURL(string:model.specImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 1)"
        countTextField.text = "\(model.productQty ?? 1)"
        perPriceLabel.text = String(model.sellPrice ?? 0).priceFormat()
        selectButton.selected = model.isSelected ?? false
        let arr = [model.color ?? "",model.specName ?? ""]
        typeArr = arr
        collectionView.reloadData()
        
        if model.productQty < model.productStock {
            addCountButton.enabled = true
            addCountButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }else {
            addCountButton.enabled = false
            addCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), forState: UIControlState.Normal)
        }
        if model.productQty <= 1 {
            subCountButton.enabled = false
            subCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), forState: UIControlState.Normal)
        }else {
            subCountButton.enabled = true
            subCountButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
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
            cell.textLabel.backgroundColor = MGRgb(245, g: 245, b: 245)
            cell.layer.borderColor = MGRgb(255, g: 255, b: 255).CGColor
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
