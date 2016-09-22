//
//  WOWUserHomeController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWUserHomeController: WOWBaseViewController {
    var goodsDataArr = [WOWGoodsModel]()
    var selectIndex:Int = 1
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Lazy
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 3
        l.minimumInteritemSpacing = 4
        l.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4)
        l.headerHeight = Float(MGScreenWidth * 2 / 3)
        return l
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRect(x: 0,y: 0,width: self.view.w,height: self.view.h), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

//MARK:Private Method
    fileprivate func initData(){
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
        self.edgesForExtendedLayout = UIRectEdge()
        configColelction()
        view.bringSubview(toFront: backButton)
    }
    
    fileprivate func configColelction(){
        view.addSubview(collectionView)
        collectionView.register(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
        collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:"WOWImageCell")
        collectionView.register(WOWUserHomeContainerView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    
//MARK:Actions
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:Delegate
extension WOWUserHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell), for: indexPath) as! WOWGoodsSmallCell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WOWUserHomeContainerView
            if let view = headerView {
                view.showData()
                //FIXME:这个地方填充数据
                view.underCheckView.delegate = self
                reusableView = view
            }
        }
        return reusableView!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWUserHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        switch selectIndex {
        case 0:
            //返回正方形
            return CGSize(width: (MGScreenWidth - 12) / 2,height: (MGScreenWidth - 12) / 2)
        case 1:
            return CGSize(width: (MGScreenWidth - 12) / 2,height: (MGScreenWidth - 12) / 2)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}


extension WOWUserHomeController:TopMenuProtocol{
    func topMenuItemClick(_ index: Int) {
        DLog("选择了第\(index)个")
    }
}



