//
//  WOWBuyCarNormalCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


protocol buyCarDelegate: class {
    func goProductDetail(_ productId: Int?)
}

class WOWBuyCarNormalCell: UITableViewCell ,TagCellLayoutDelegate{

    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCountButton: UIButton!
    @IBOutlet weak var addCountButton: UIButton!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    let identifier = "WOWTypeCollectionCell"
    var typeArr = [String]()
    var model:WOWCarProductModel!
    weak var delegate: buyCarDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultSetup()
    }
    
    func defaultSetup() {
        let nib = UINib(nibName:"WOWTypeCollectionCell", bundle:Bundle.main)
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
        let tagCellLayout = TagCellLayout(tagAlignmentType: .left, delegate: self)
        collectionView?.collectionViewLayout = tagCellLayout
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(_ model:WOWCarProductModel?) {
        guard let model = model else{
            return
        }
        self.model = model
//        goodsImageView.kf_setImageWithURL(NSURL(string:model.specImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        goodsImageView.set_webimage_url( model.specImg! )
        
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 1)"
        countTextField.text = "\(model.productQty ?? 1)"
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        perPriceLabel.text = result
        selectButton.isSelected = model.isSelected ?? false
        let arr = [model.color ?? "",model.specName ?? ""]
        typeArr = arr
        collectionView.reloadData()
        
        if model.productQty < model.productStock {
            addCountButton.isEnabled = true
            addCountButton.setTitleColor(UIColor.black, for: UIControlState())
        }else {
            addCountButton.isEnabled = false
            addCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
        }
        if model.productQty <= 1 {
            subCountButton.isEnabled = false
            subCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
        }else {
            subCountButton.isEnabled = true
            subCountButton.setTitleColor(UIColor.black, for: UIControlState())
        }
        detailView.addTapGesture {[weak self] (tap) in
            if let strongSelf = self {
                if let del = strongSelf.delegate {
                    del.goProductDetail(model.parentProductId)
                }
            }
            
        }
       
    }

   
    
    
    
    //MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(_ layout: TagCellLayout) -> CGFloat {
        return CGFloat(28.0)
    }
    
    func tagCellLayoutTagWidth(_ layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        

            let item = typeArr[index]
            let title = item 
            let width = title.size(Fontlevel004).width + 12
            return width
        
    }
    //MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WOWTypeCollectionCell
                let item = typeArr[(indexPath as NSIndexPath).row]
                cell.textLabel.text = item
        return cell
            
    }
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeArr == nil ? 0 : (typeArr.count)
    }

 
}
