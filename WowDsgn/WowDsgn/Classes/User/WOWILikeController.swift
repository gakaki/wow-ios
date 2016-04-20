//
//  WOWILikeController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWILikeController: WOWBaseViewController {
    var selectIndex:Int = 1
    var checkView:WOWTopMenuTitleView!
    var goodsDataArr = [WOWGoodsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Lazy
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        l.minimumColumnSpacing = 1
        l.minimumInteritemSpacing = 1
        return l
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRectMake(0, 45,self.view.width,self.view.height - 45 - 64), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()


//MARK:Private Method
    private func initData(){
        //FIXME:测试数据
        let string = ["年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造"," 11208"]
        for index in 1...40 {
            let model = WOWGoodsModel()
            model.des = string[index % 2 ]
            model.calCellHeight()
            goodsDataArr.append(model)
        }
        collectionView.reloadData()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "我喜欢的"
        configColelction()
        configCheck()
    }
    
    private func configColelction(){
        view.addSubview(collectionView)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
       collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:"WOWImageCell")
    }
    
    private func configCheck(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = false
        WOWCheckMenuSetting.selectedIndex = selectIndex
        checkView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, MGScreenWidth, 40), titles: ["喜欢的场景","喜欢的单品"])
        checkView.delegate = self
        WOWBorderColor(checkView)
        self.view.addSubview(checkView)
    }
    
}


extension WOWILikeController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        DLog("\(index)")
    }
}


extension WOWILikeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var returnCell : UICollectionViewCell!
        switch selectIndex {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
            returnCell = cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
            
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if selectIndex == 0 { //场景
            let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
            sence.hideNavigationBar = true
            navigationController?.pushViewController(sence, animated: true)
        }else{//单品
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
            vc.hideNavigationBar = true
//            vc.goodsDetailEntrance = .FromGoodsList
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension WOWILikeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch selectIndex {
        case 0:
            //返回正方形
            return CGSizeMake(WOWGoodsSmallCell.itemWidth, WOWGoodsSmallCell.itemWidth)
        case 1:
            return CGSizeMake(WOWGoodsSmallCell.itemWidth,goodsDataArr[indexPath.item].cellHeight)
        default:
            return CGSizeMake(0, 0)
        }
    }
}




