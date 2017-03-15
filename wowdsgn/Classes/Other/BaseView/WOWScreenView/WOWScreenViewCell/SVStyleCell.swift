//
//  SVStyleCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol SVStyleCellDelegate:class{
    
    func updataStyleTableViewCellHight(cell: SVStyleCell,hight: CGFloat,indexPath: NSIndexPath)
    
}
class SVStyleCell: UITableViewCell {
    
    var dataArr:[ScreenModel]?{
        didSet{
            collectionView.reloadData()
        }
    }
    var indexPathNow  :NSIndexPath!
    weak var delegate : SVStyleCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var currentVCType:CategoryEntrance  = .category
    
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib.nibName("StyleCVCell"), forCellWithReuseIdentifier: "StyleCVCell")
//        collectionView.setCollectionViewLayout(self.layout, animated: true)
//        collectionView.layout
        collectionView.backgroundColor = GrayColorLevel5
        collectionView.delegate = self
        collectionView.dataSource = self

    }
//    var layout:CollectionViewWaterfallLayout = {
//        let l = CollectionViewWaterfallLayout()
//        l.columnCount = 2
//        l.minimumColumnSpacing = 0
//        l.minimumInteritemSpacing = 0
//        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        
//        return l
//    }()
    func updateCollectionViewHight(hight :CGFloat)  {
        
        self.collectionViewHeight.constant = hight
        self.delegate?.updataStyleTableViewCellHight(cell: self, hight: hight, indexPath: self.indexPathNow)
        
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SVStyleCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StyleCVCell", for: indexPath as IndexPath) as! StyleCVCell
        
        
        let model = dataArr?[indexPath.row]
        cell.showData(m: model!)
//        cell.backgroundColor = UIColor.red
        self.updateCollectionViewHight(hight: self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var styleInt = 3 //
        switch currentVCType {
            
        case .scene:
            styleInt = 2
        default:
            styleInt = 3
        }

        switch indexPathNow.section {
        case styleInt:
            
            var params : [String: AnyObject]
            params = (dataArr?.getScreenCofig(index: indexPath.row,dicKey: "styleIdArr"))!
            NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)
            collectionView.reloadData()
            
        case 1:
            var params : [String: AnyObject]
            params = (dataArr?.getScreenCofig(index: indexPath.row,dicKey: "screenIdArr"))!
            NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)
            collectionView.reloadData()
        default:
            break
        }
        
        
        
    }

    func clickItem(sender:UIButton) {
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (bounds.width)/2 - 5,height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0,0,0)
    }
    
  
    
}
