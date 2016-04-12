//
//  WOWGoodsController.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum GoodsCellStyle {
    case Big,Small
}


class WOWGoodsController: WOWBaseViewController {
    private var cellBigId = String(WOWGoodsBigCell)
    private var cellSmallId = String(WOWGoodsSmallCell)
    var menuIndex:Int = 0
    var menuView: BTNavigationDropdownMenu!
    private var cellShowStyle:GoodsCellStyle = .Big
    
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
        
                           
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
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
        l.columnCount = 1
        l.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        l.minimumColumnSpacing = 1
        l.minimumInteritemSpacing = 1
        return l
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRectMake(0, 45,self.view.width,self.view.height - 45), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        view.addSubview(collectionView)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsBigCell)), forCellWithReuseIdentifier: cellBigId)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: cellSmallId)
        configNavigation()
        configMenuView()
    }
    
    private func configMenuView(){
        WOWDropMenuSetting.columnTitles = ["综合排序","风格"]
        //FIXME:测试数据
        WOWDropMenuSetting.rowTitles =  [
                                            ["销量","价格","信誉","性价比吧","口碑吧"],
                                            ["现代简约","中式传统","清新田园","古朴禅意","自然清雅","经典怀旧","LOFT工业风","商务质感","玩味童趣","后现代"]
                                        ]
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.cellTextLabelSelectColoror = GrayColorlevel2
        WOWDropMenuSetting.showDuration = 0.2
        let menuView = WOWDropMenuView(frame:CGRectMake(0,0,MGScreenWidth,44))
        menuView.delegate = self
        menuView.addSubview(styleButton)
        styleButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(menuView.snp_centerY)
            make.right.bottom.equalTo(menuView).offset(-15)
        }
        
        view.addSubview(menuView)
        
    }
    
    private func configNavigation(){
        let items = WOWMenus
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[menuIndex], items: items,defaultSelectIndex: menuIndex)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.whiteColor()
        menuView.cellSelectionColor = ThemeColor
        menuView.cellTextLabelColor = UIColor.blackColor()
        menuView.cellTextLabelFont = Fontlevel001
        menuView.cellTextLabelAlignment = .Left
        menuView.arrowPadding = 8
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.cellSeparatorColor = BorderColor
        menuView.checkMarkImage = UIImage(named: "duihao")
        menuView.arrowImage = UIImage(named:"nav_arrow")
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            DLog("Did select item at index: \(indexPath)")
        }
        self.navigationItem.titleView = menuView
    }

    
//MARK:Actions
    func showStyleChange(btn:UIButton) {
        btn.selected = !btn.selected
        cellShowStyle = btn.selected ? .Small : .Big
        layout.columnCount = btn.selected ? 2 : 1
        collectionView.reloadData()
    }
}




//MARK:Delegate
extension WOWGoodsController:DropMenuViewDelegate{
    func dropMenuClick(column: Int, row: Int) {
        DLog("选择了第\(column)列，第\(row)行")
    }
}

extension WOWGoodsController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch cellShowStyle {
        case .Big:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellBigId, forIndexPath: indexPath) as! WOWGoodsBigCell
            cell.showData()
            cell.delegate = self
            return cell
        case .Small:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellSmallId, forIndexPath: indexPath) as! WOWGoodsSmallCell
            cell.showData()
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWGoodsController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((MGScreenWidth - 3) / 2,(MGScreenWidth - 3) / 2 + CGFloat(indexPath.row * 2))
    }
}


extension WOWGoodsController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            DLog("喜欢")
        case WOWItemActionType.Share.rawValue:
            DLog("分享")
        case WOWItemActionType.Brand.rawValue:
            DLog("品牌")
        default:
            DLog(" ")
        }
    }
}


