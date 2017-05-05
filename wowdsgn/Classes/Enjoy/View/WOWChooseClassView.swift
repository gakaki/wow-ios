//
//  WOWChooseClassView.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/4.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
protocol ChooseClassBackDelegate:class{
    

    func didSelectItem(_ classId:Int)
}
class WOWChooseClassBackView: UIView,ChooseClassDelegate,CAAnimationDelegate {
    
   
    weak var delegate : ChooseClassBackDelegate?
    //MARK:*****************************背景视图******************************************

        //MARK:Lazy
        lazy var selectView:WOWChooseClassView = {
            let v = Bundle.loadResourceName(String(describing: WOWChooseClassView.self)) as! WOWChooseClassView
            v.isUserInteractionEnabled = true
            v.delegate = self
            return v
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)

        }
    
        init(frame: CGRect, cellNumber:Int) {
            super.init(frame: frame)
            self.frame = frame
            backgroundColor = MaskColor
            self.alpha = 0
            setUP(cellNumber: cellNumber)
        }
    

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var dismissButton:UIButton = {
            let b = UIButton(type: .system)
            b.backgroundColor = UIColor.clear
            return b
        }()
        //MARK:Private Method
        fileprivate func setUP(cellNumber:Int){
            
            addSubview(selectView)
            let a = ((cellNumber % 3) == 0 ? (cellNumber / 3) : ((cellNumber / 3) + 1))
            let hight = (a * 127) + 85
            let maxH = Int(MGScreenHeight - 110)
            let h = (hight > maxH ? maxH  : hight)
          
            selectView.snp.makeConstraints {[weak self](make) in
                if let strongSelf = self{
                    make.left.equalTo(strongSelf).offset(15)
                    make.right.equalTo(strongSelf).offset(-15)
                    make.height.equalTo(h)
                    make.centerX.equalTo(strongSelf)
                    make.centerY.equalTo(strongSelf).offset(Int(strongSelf.h) + (h/2))

                }
            }
            insertSubview(dismissButton, belowSubview: selectView)
            dismissButton.snp.makeConstraints {[weak self](make) in
                if let strongSelf = self{
                    make.left.bottom.right.equalTo(strongSelf).offset(0)
                    make.top.equalTo(strongSelf).offset(0)
                }
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    
        func updataChooseClassViewHight(_ hight: CGFloat){
            
//            selectView.snp.updateConstraints { (make) in
//                make.height.equalTo(hight)
//            }
            
        }
        func didSelectItem(_ classId:Int) {
            if let del = delegate {
                del.didSelectItem(classId)
            }
        }
        //MARK:Actions
        func show() {
            selectView.snp.updateConstraints {[unowned self] (make) in
                  make.centerY.equalTo(self)
            }
            self.setNeedsLayout()
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                if let strongSelf = self {
                    strongSelf.alpha = 1
                    strongSelf.layoutIfNeeded()
                }
                
            })
        }
        
        func closeButtonClick()  {

            hideView()
        }
        
        func hideView(){
            selectView.snp.updateConstraints {[unowned self] (make) in
              make.centerY.equalTo(self).offset(Int(self.h) + Int(self.selectView.h/2))
            }
            
            self.setNeedsLayout()
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                if let strongSelf = self {
                    strongSelf.alpha = 0
                    strongSelf.layoutIfNeeded()
                    
                }
                
                }, completion: {[weak self] (ret) in
                    if let strongSelf = self {
                        strongSelf.removeFromSuperview()
                        
                    }
            })
        }
    

    


}

protocol ChooseClassDelegate:class{
    
    func updataChooseClassViewHight(_ hight: CGFloat)
    
    func didSelectItem(_ classId:Int)
}
class WOWChooseClassView: UIView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var px = (MGScreenWidth - 30 - (80 * 3)) / 4
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryArr = [WOWEnjoyCategoryModel](){// 为true 则是从专题详情内点击进来
        didSet{
          collectionView.reloadData()
//            self.updateCollectionViewHight(hight: self.collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    weak var delegate : ChooseClassDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTable()
        
    }
    func updateCollectionViewHight(hight: CGFloat){
        let maxH = MGScreenHeight - 110
        let h = (hight > maxH ? maxH  : hight)
        if let del = delegate{
            del.updataChooseClassViewHight(h)
        }
        self.heightConstraint.constant = h
    }
    fileprivate func configTable(){
        
        collectionView.register(UINib.nibName(String(describing: WOWChoiseClassCell.self)), forCellWithReuseIdentifier: "WOWChoiseClassCell")
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.showsHorizontalScrollIndicator   = false

    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return categoryArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWChoiseClassCell", for: indexPath) as! WOWChoiseClassCell
        
        cell.showData(categoryArr[indexPath.row])

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
          return CGSize(width: 80 ,height: 127)
        }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
           return UIEdgeInsetsMake(0, px,15, px)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let classId = indexPath.row
        if let del = delegate {
            del.didSelectItem(classId)
        }
    }

}
