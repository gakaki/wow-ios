//
//  WOWGoodsBuyView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsBuyView: UIView,TagCellLayoutDelegate{

    @IBOutlet weak var countTextField: UITextField!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
//    var autoLayoutHeight:CGFloat = 0
    var token: dispatch_once_t = 0
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit{
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSetup()
    }
    

//MARK:Private Method
    func defaultSetup() {
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "WOWTagCollectionViewCell")
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)
        
        collectionView?.collectionViewLayout = tagCellLayout
        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
        
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        dispatch_once(&token) {
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize().height
            guard height != self.collectionView.size.height else{
                return
            }
            if height > 200 {
                self.collectionViewHeight.constant = 200
            }else{
                self.collectionViewHeight.constant = height
            }
//            self.autoLayoutHeight = self.collectionViewHeight.constant  + 250
//            DLog("view的高度\(self.autoLayoutHeight)")
            DLog("规格的collectionView的高度\(height)")
        }
    }

    
//MARK:Actions
    @IBAction func closeButtonClick(sender: UIButton) {
        
    }
    
    @IBAction func countButtonClick(sender: UIButton) {
        
        
    }
    @IBAction func sureButtonClick(sender: UIButton) {
        
    }


    
//MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        //FIXME:测试数据
        return CGFloat(125 + arc4random()%100)
    }

    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "WOWTagCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
        cell.textLabel.text = "123123"
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        debugPrint("123")
    }
}



