//
//  WOWOrderListCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWOrderListCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var goodsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightViseButton: UIButton!
    
    //单个的
    @IBOutlet weak var singleBackView: UIView!
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var singleNameLabel: UILabel!
    @IBOutlet weak var singleTypeLabel: UILabel!
    
    let statuTitles = ["待付款","待发货","待收货","待评价","已完成"]
    let rightTitles = ["立即支付","","确认收货","评价","删除订单"]
    var dataArr = [WOWOrderProductModel] ()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetSeparators()
        collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:"WOWImageCell")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(model:WOWOrderListModel){
        if model.products?.count > 1 {
            collectionView.hidden = false
            singleBackView.hidden = true
            dataArr = model.products!
            collectionView.reloadData()
        }else{
            let itemModel = model.products?.first
            singleImageView.kf_setImageWithURL(NSURL(string:itemModel?.imageUrl ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
            singleNameLabel.text = itemModel?.name
            singleTypeLabel.text = itemModel?.sku_title
            collectionView.hidden = true
            singleBackView.hidden = false
            dataArr = [ ]
        }
        orderIdLabel.text = model.id
        goodsCountLabel.text = "共\(model.products?.count ?? 1)件商品"
        totalPriceLabel.text = model.total?.priceFormat()
        configShowStatus(model.status!)
    }
    
    @IBAction func rightButtonClick(sender: UIButton) {
        if sender.tag == 1002 { //右1
            
        }else{ //右2
            
        }
    }
    
    private func configShowStatus(status:Int){
        rightButton.setTitle(rightTitles[status], forState: .Normal)
        statusLabel.text = statuTitles[status]
        rightViseButton.hidden = true
        rightButton.hidden = false
        rightButton.backgroundColor = ThemeColor
        rightButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        WOWBorderColor(rightButton)
        switch status {
        case 0: //待付款
            statusLabel.textColor = UIColor.redColor()
        case 1: //待发货
            rightButton.hidden = true
            rightViseButton.hidden = true
            statusLabel.text = "待发货"
            statusLabel.textColor = UIColor.orangeColor()
        case 2: //待收货 查看物流
            statusLabel.textColor = MGRgb(255, g: 150, b: 0)
            rightViseButton.hidden = false
            rightViseButton.borderColor(0.5, borderColor:UIColor.blackColor())
            rightViseButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
            rightViseButton.setTitle("查看物流", forState: .Normal)
        case 3: //待评价
            statusLabel.textColor = MGRgb(0, g: 118, b: 255)
        case 4: //已完成
            statusLabel.textColor = UIColor.blackColor()
            rightButton.borderColor(0.5, borderColor:UIColor.redColor())
            rightButton.backgroundColor = UIColor.whiteColor()
            rightButton.setTitleColor(UIColor.redColor(), forState:.Normal)
        default:
            break
        }
    }
    
}

extension WOWOrderListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        let model = dataArr[indexPath.row]
        cell.pictureImageView.kf_setImageWithURL(NSURL(string:model.imageUrl ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 15, 10, 15)
    }
    
}
