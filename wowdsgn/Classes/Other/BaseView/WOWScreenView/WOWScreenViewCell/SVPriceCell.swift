//
//  SVPriceCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol SVPriceCellDelegate:class{
    
    func updataTableViewCellHightFormPrice(cell: SVPriceCell,hight: CGFloat,indexPath: NSIndexPath)
    
}

class SVPriceCell: UITableViewCell {
    let identifier = "WOWTagCollectionViewCell"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var indexPathNow:NSIndexPath!
    weak var delegate : SVPriceCellDelegate?
    var dataArr:[ScreenModel]?{
        didSet{
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = GrayColorLevel5
        //价格区间视图
        let nib = UINib(nibName:"PriceCVCell", bundle:Bundle.main)
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
  
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = GrayColorLevel5
//        let tagCellLayout = TagCellLayout(tagAlignmentType: .Center, delegate: self)
//        collectionView?.collectionViewLayout = tagCellLayout
//        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)

    }
   override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        var endHeight:CGFloat = 61
        if UIDevice.deviceType.rawValue < 2{
            endHeight = 61
        }
        
        if height > endHeight {
            self.collectionViewHeight.constant = endHeight
        }else{
            self.collectionViewHeight.constant = height
        }
        DLog("颜色的collectionView的高度\(height)")
        
    }
    func updateCollectionViewHight(hight :CGFloat)  {
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(hight)
        }
        self.delegate?.updataTableViewCellHightFormPrice(cell: self, hight: hight, indexPath: self.indexPathNow)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
extension SVPriceCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath) as! PriceCVCell
        let cellModel = dataArr![indexPath.row]
        
        cell.textLabel.text = (cellModel.min?.toString)! + "-" + (cellModel.max?.toString)!
        if cellModel.isSelect == true {
            cell.textLabel.backgroundColor =  UIColor.white
//            SelectColorOrange
        }else{
            cell.textLabel.backgroundColor = UIColor.white
        }
        self.updateCollectionViewHight(hight: self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.w,height: 35.h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var params : [String: AnyObject]
        params = (dataArr?.getScreenCofig(index: indexPath.row,dicKey: "priceArr",isPrice: true))!
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)

        collectionView.reloadData()
    }
    
//    MARK: - TagCellLayout Delegate Methods
//    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
//        return CGFloat(45.0)
//    }
//    
//    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
//        
//        
//        let title = "0-10000"
//        let width = title.size(Fontlevel004).width + 45
//        return width
//        
//        
//    }

}
