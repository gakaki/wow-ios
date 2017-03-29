//
//  WOWOtherCenterController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/29.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOtherCenterController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 3
        l.minimumColumnSpacing = 3
        l.minimumInteritemSpacing = 3
        l.sectionInset = UIEdgeInsetsMake(3, 3, 0, 3)
        l.headerHeight = 233
        return l
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
          }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = UIRectEdge()
        configCollectionView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化产品列表
    func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.mj_header  = self.mj_header
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.nibName(String(describing: WOWWorksCell.self)), forCellWithReuseIdentifier:String(describing: WOWWorksCell.self))
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
        collectionView.register(UINib.nibName(String(describing: WOWOtherHeaderView.self)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    

    
 
    
    //MARK:Network
    override func request() {
        super.request()
        
    }
    
    
}


extension WOWOtherCenterController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWWorksCell.self), for: indexPath) as! WOWWorksCell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WOWOtherHeaderView
            if let view = headerView {
               
                reusableView = view
            }
        }
        return reusableView!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}



extension WOWOtherCenterController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWWorksCell.itemWidth,height: WOWWorksCell.itemWidth)
    }
}


