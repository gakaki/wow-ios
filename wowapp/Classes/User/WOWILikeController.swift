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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        l.minimumColumnSpacing = 0.5
        l.minimumInteritemSpacing = 0.5
        return l
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRect(x: 0, y: 40,width: self.view.w,height: self.view.h - 40 - 64), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource   = self
        collectionView.backgroundColor = DefaultBackColor
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
    
    fileprivate func configColelction(){
        view.addSubview(collectionView)
        collectionView.mj_footer = self.mj_footer
        collectionView.mj_header = self.mj_header
        collectionView.register(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
        collectionView.mj_header = self.mj_header
        collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:"WOWImageCell")
    }
    
    fileprivate func configCheck(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = false
        WOWCheckMenuSetting.selectedIndex = selectIndex
        checkView = WOWTopMenuTitleView(frame:CGRect(x: 0, y: 0, width: self.view.w, height: 40), titles: ["喜欢的场景","喜欢的单品"])
        checkView.delegate = self
        WOWBorderColor(checkView)
        self.view.addSubview(checkView)
    }
    
//MARK:Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_UserFavorite(uid:uid, type:type,pageindex:"\(pageIndex))"), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let totalPage = JSON(result)["totalPages"].int ?? 0
                if totalPage == 0 || strongSelf.pageIndex == totalPage - 1 {
                    strongSelf.collectionView.mj_footer = nil
                }else{
                    strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                }
                let json = JSON(result)["likes"].arrayObject
                if let js = json{
                    if strongSelf.pageIndex == 0{
                        strongSelf.dataArr = []
                    }
                        for item in js{
                        let model = Mapper<WOWFavoriteListModel>().map(item)
                        if let m = model{
                            strongSelf.dataArr.append(m)
                        }
                    }
                    strongSelf.collectionView.reloadData()
                }
                strongSelf.endRefresh()
            }
        }) { [weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
}


extension WOWILikeController:TopMenuProtocol{
    func topMenuItemClick(_ index: Int) {
        selectIndex = index
        pageIndex = 0
        request()
    }
}


extension WOWILikeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell : UICollectionViewCell!
        let model = dataArr[(indexPath as NSIndexPath).row]
        switch selectIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWImageCell", for: indexPath) as! WOWImageCell
            cell.pictureImageView.set_webimage_url(model.imgUrl );

            returnCell = cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWGoodsSmallCell", for: indexPath) as! WOWGoodsSmallCell            
            cell.pictureImageView.set_webimage_url(model.imgUrl );

            cell.desLabel.text = model.name
            cell.priceLabel.text = model.price?.priceFormat()
            
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).row]
        if selectIndex == 0 { //场景
            let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
            sence.hideNavigationBar = true
            sence.sceneID = String(model.id)
            navigationController?.pushViewController(sence, animated: true)
        }else{ //单品
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
            vc.productId = model.id
            vc.hideNavigationBar = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func titleForEmptyDataSet(_ scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无您喜欢的" + (selectIndex == 0 ? "场景哦...":"单品哦...")
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    func verticalOffsetForEmptyDataSet(_ scrollView: UIScrollView!) -> CGFloat {
        return -40
    }
}


extension WOWILikeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        switch selectIndex {
        case 0:
            return CGSize(width: WOWImageCell.itemWidth, height: WOWImageCell.itemWidth)
        case 1:
            return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 65)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 0, 0)
    }
}




