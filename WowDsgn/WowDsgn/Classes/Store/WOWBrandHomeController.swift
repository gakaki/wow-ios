//
//  WOWBrandHomeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBrandHomeController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    var dataArr = [WOWGoodsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    //MARK:Lazy
    lazy var styleButton:UIButton = {
        let b = UIButton(type:.System)
        b.setImage(UIImage(named: "store_style_small")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
        b.setImage(UIImage(named: "store_style_big")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Selected)
        b.addTarget(self, action:#selector(WOWGoodsController.showStyleChange(_:)), forControlEvents:.TouchUpInside)
        b.tintColor = UIColor.whiteColor()
        return b
    }()
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 1
        l.minimumInteritemSpacing = 1
        l.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1)
        l.headerHeight = Float(MGScreenWidth * 2 / 3)
        return l
    }()

    
//MARK:Private Method
    private func initData(){
        //FIXME:测试数据
        let string = ["年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造"," 11208"]
        for index in 1...40 {
            let model = WOWGoodsModel()
            model.des = string[index % 2 ]
            model.calCellHeight()
            dataArr.append(model)
        }
        collectionView.reloadData()
    }
    
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = .None
        configCollectionView()
    }
    private func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
        collectionView.registerClass(WOWBrandTopView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
        
    }
    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}


extension WOWBrandHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
        cell.showData(dataArr[indexPath.row])
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as? WOWBrandTopView
            if let view = headerView {
                //FIXME:这个地方填充数据
                view.topHeadView.delegate = self
                view.underHeadView.delegate = self
                reusableView = view
            }
        }
        return reusableView!
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        vc.goodsDetailEntrance = .FromBrand
        WOWMediator.goodsDetailSecondEntrance = GoodsDetailEntrance.FromBrand
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWBrandHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = dataArr[indexPath.item]
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,model.cellHeight)
    }
}

extension WOWBrandHomeController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            DLog("喜欢")
        case WOWItemActionType.Share.rawValue:
            DLog("分享")
        case WOWItemActionType.Brand.rawValue:
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandDetailController)) as! WOWBrandDetailController
            presentViewController(vc, animated: true, completion: nil)
        default:
            DLog("")
        }
    }
}
