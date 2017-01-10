//
//  SVColorCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol SVColorCellDelegate:class{
    
    func updataTableViewCellHight(cell: SVColorCell,hight: CGFloat,indexPath: NSIndexPath)

}
class SVColorCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var indexPathNow:NSIndexPath!
    weak var delegate : SVColorCellDelegate?
    
    var dataArr:[ScreenModel]?{
        didSet{
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
   
        self.resetSeparators()
        
        collectionView.register(UINib.nibName("ColorCVCell"), forCellWithReuseIdentifier: "ColorCVCell")

        collectionView.backgroundColor = GrayColorLevel5
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
//        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context:nil)
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

        self.collectionViewHeight.constant = hight
        self.delegate?.updataTableViewCellHight(cell: self, hight: hight, indexPath: self.indexPathNow)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SVColorCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCVCell", for: indexPath as IndexPath) as! ColorCVCell
        //FIX 测试数据
        let cellModel = dataArr![indexPath.row]

        if let moduleImage = cellModel.imgurl {
            
            DispatchQueue.main.async {
               cell.imgColor.set_webimage_url(moduleImage)
            }

        }
        cell.imgColor.tag = indexPath.row

        self.updateCollectionViewHight(hight: self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30.w,height: 30.h)
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var params : [String: AnyObject]
        params = (dataArr?.getScreenCofig(index: indexPath.row,dicKey: "colorIdArr"))!
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)
    }
    
}
extension Array {
    
    func getScreenCofig(index: Int,dicKey: String,isPrice: Bool = false) -> Dictionary<String, AnyObject> {
        var params : [String: AnyObject]
        let cellModel = self[index] as? ScreenModel
        
        if  cellModel!.isSelect {
            cellModel!.isSelect = false
        }else{
            cellModel!.isSelect = true
        }

        guard isPrice == false else {
            
            var priceRangDic = [String: AnyObject]()
            for index in 0 ..< self.count {
                let model = self[index] as? ScreenModel
                if model!.isSelect {
                    
                    if let min = model?.min,let max = model?.max{
                        
                        priceRangDic = ["min":min as AnyObject,"max":max as AnyObject]
                        
                    }
                    
                }
            }
            params = [dicKey: priceRangDic as AnyObject]
            return params

        }

        var colorIdArr = [String]()
        for index in 0 ..< self.count {
               let model = self[index] as? ScreenModel
               if model!.isSelect {
                
                  if let modelId = model?.id{
                    
                     colorIdArr.append(modelId.toString)
                    
                   }
                
            }
        }
        params = [dicKey: colorIdArr as AnyObject]
        return params
    }
}
