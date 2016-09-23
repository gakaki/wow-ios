//
//  WOWProductOrderCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/18.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductOrderCell: UITableViewCell ,TagCellLayoutDelegate{

    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var subCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let identifier = "WOWTypeCollectionCell"
    var typeArr = [String]()
    var model:WOWCarProductModel!
    
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
        
        goodsImageView.set_webimage_url(model.specImg)
        
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 1)"
        subCountLabel.text = "共\(model.productQty ?? 1)件"
        let result1 = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        perPriceLabel.text = result1
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[model.productQty ?? 1])
        totalPriceLabel.text = result
        let arr = [model.color ?? "",model.specName ?? ""]
        typeArr = arr
        collectionView.reloadData()
        
    }
    
    
    
    
    
    //MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(_ layout: TagCellLayout) -> CGFloat {
        return CGFloat(28.0)
    }
    
    func tagCellLayoutTagWidth(_ layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        
        
        let item = typeArr[index]
        let title = item ?? ""
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
        return typeArr == nil ? 0 : (typeArr.count)!
    }
    
}
