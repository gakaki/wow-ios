//
//  WOWILikeController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWILikeController: WOWBaseViewController {
    var selectIndex:Int = 0{
        didSet{
            type = selectIndex == 0 ? "2" : "1"
        }
    }
    var type = "1"  //type 1为商品  2为场景
    var checkView:WOWTopMenuTitleView!
    var dataArr = [WOWFavoriteListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
//MARK:Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_UserFavorite(uid:uid, type:type), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result).arrayObject
                if let js = json{
                    strongSelf.dataArr = []
                    for item in js{
                        let model = Mapper<WOWFavoriteListModel>().map(item)
                        if let m = model{
                            strongSelf.dataArr.append(m)
                            if strongSelf.type == "1"{ //商品的
                                m.calCellHeight()
                            }
                        }
                    }
                    strongSelf.collectionView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
}


extension WOWILikeController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        selectIndex = index
        request()
    }
}


extension WOWILikeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var returnCell : UICollectionViewCell!
        let model = dataArr[indexPath.row]
        switch selectIndex {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
            cell.pictureImageView.kf_setImageWithURL(NSURL(string:model.imgUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
            returnCell = cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
            cell.pictureImageView.kf_setImageWithURL(NSURL(string:model.imgUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
            cell.desLabel.text = model.name
            //FIXME:要提醒tom哥更改过来哦
            cell.priceLabel.text = model.price?.priceFormat()
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        if selectIndex == 0 { //场景
            let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
            sence.hideNavigationBar = true
            sence.senceID = model.id
            navigationController?.pushViewController(sence, animated: true)
        }else{//单品
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
            vc.productID = model.id
            vc.hideNavigationBar = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension WOWILikeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch selectIndex {
        case 0:
//            //返回正方形
            return CGSizeMake(WOWImageCell.itemWidth, WOWImageCell.itemWidth)
        case 1:
            return CGSizeMake(WOWGoodsSmallCell.itemWidth,dataArr[indexPath.item].cellHeight)
        default:
            return CGSizeMake(0, 0)
        }
    }
}




