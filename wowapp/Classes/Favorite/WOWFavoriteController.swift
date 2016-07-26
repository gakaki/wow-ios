//
//  WOWFavoriteController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWFavoriteController: WOWBaseViewController {
    var menuView:WOWTopMenuTitleView!
     @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configCheckView()
        configCollectionView()

    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0.5
        l.minimumInteritemSpacing = 0.5
        l.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1)
        return l
    }()
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.registerNib(UINib.nibName(String(WOWFavoritrSingleCell)), forCellWithReuseIdentifier:String(WOWFavoritrSingleCell))
        WOWBorderColor(collectionView)

    }
    

    private func configCheckView(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.margin = 40
        WOWCheckMenuSetting.titleFont = UIFont.systemScaleFontSize(14)
        WOWCheckMenuSetting.fill = true

        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, self.view.w, 40), titles: ["单品","品牌","设计师"])
        menuView.delegate = self
        menuView.addBorderBottom(size:0.5, color:BorderColor)
        self.view.addSubview(menuView)
    }

  
    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView! {
        let view = NSBundle.mainBundle().loadNibNamed(String(FavoriteEmpty), owner: self, options: nil).last as! FavoriteEmpty

        view.goStoreButton.addTarget(self, action:#selector(goStore), forControlEvents:.TouchUpInside)
            
        return view
    }

    
    func goStore() -> Void {
        print("去逛逛")
    }
}
extension WOWFavoriteController:UICollectionViewDelegate,UICollectionViewDataSource{

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFavoritrSingleCell), forIndexPath: indexPath) as! WOWFavoritrSingleCell
        cell.imageView.image = UIImage(named: "favoritrEmpty")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
}
extension WOWFavoriteController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWFavoritrSingleCell.itemWidth,WOWFavoritrSingleCell.itemWidth)
    }
}
//MARK:Delegate
extension WOWFavoriteController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        DLog("\(index)")
    }
}
