//
//  WOWGoodsBuyView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsBuyView: UIView {

    @IBOutlet weak var countTextField: UITextField!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
    
    func defaultSetup() {
        let nib = UINib(nibName:"WOWSearchCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "WOWSearchCell")
    }
    
//MARK:Actions
    @IBAction func closeButtonClick(sender: UIButton) {
        
        
    }
    
    @IBAction func countButtonClick(sender: UIButton) {
        
        
    }
    @IBAction func sureButtonClick(sender: UIButton) {
        
    }

    
//MARK: - UICollectionView Delegate/Datasource Methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "TagCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        debugPrint("123")
    }

    
    
}




