//
//  WOWStoreController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWStoreController: WOWBaseViewController {
    let cellID1  = String(WOWStoreBrandCell)
    let cellID2 = String(WOWMenuCell)
    var categoryArr = [WOWCategoryModel]()
    var brandArr    = [WOWBrandListModel]()
    var bannerArr   = [WOWBannerModel]()
    var cycleView:CyclePictureView!
    var brandsCount : Int = 0
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.registerNib(UINib.nibName(String(WOWStoreBrandCell)), forCellReuseIdentifier:cellID1)
        tableView.clearRestCell()
        
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth * 215/375), imageURLArray: nil)
        cycleView.delegate = self
        //FIXME:默认图片
        cycleView.placeholderImage = UIImage(named: "test2")
        tableView.tableHeaderView = cycleView
        tableView.mj_header = mj_header
    }
    
    private func configHeaderView(){
        cycleView.imageURLArray = bannerArr.map({ (model) -> String in
            return model.imageUrl ?? ""
        })
    }
 
//MARK:Actions


//MARK:Private Network
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_StoreHome, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.categoryArr = []
                strongSelf.bannerArr   = []
                strongSelf.brandArr    = []
                strongSelf.brandsCount = JSON(result)["brands_count"].intValue
                let brands = Mapper<WOWBrandListModel>().mapArray(JSON(result)["brands"].arrayObject)
                if let brandArray = brands{
                    strongSelf.brandArr.appendContentsOf(brandArray)
                }
                let banners = Mapper<WOWBannerModel>().mapArray(JSON(result)["story"].arrayObject)
                if let bannerArray = banners{
                    strongSelf.bannerArr.appendContentsOf(bannerArray)
                }
                let cates = Mapper<WOWCategoryModel>().mapArray(JSON(result)["cats"].arrayObject)
                if let cateArr = cates{
                    strongSelf.categoryArr.appendContentsOf(cateArr)
                }
                strongSelf.endRefresh()
                strongSelf.configHeaderView()
                strongSelf.tableView.reloadData()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
}


extension WOWStoreController:CyclePictureViewDelegate{
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = bannerArr[indexPath.item]
        guard let string = model.url else{
            return
        }
        let vc = UIStoryboard.initialViewController("Activity", identifier:"WOWActivityDetailController") as! WOWActivityDetailController
        vc.url = string
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWStoreController:BrandCellDelegate{
    func hotBrandCellClick(brandModel: WOWBrandListModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWStoreController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return categoryArr.count
        }else{
            return  1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell
        if indexPath.section == 1{ //品牌
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
            cell.dataArr = self.brandArr
            cell.delegate = self
            tableViewCell = cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2, forIndexPath: indexPath) as! WOWMenuCell
            cell.showDataModel(categoryArr[indexPath.row],isStore:true)
            tableViewCell = cell
        }
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1{
            return MGScreenWidth
        }else{
            return 50
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { //分类
            let item = categoryArr[indexPath.row]
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
            vc.navigationItem.title = item.categoryName
            vc.menuIndex = indexPath.row
            vc.menuTitles = categoryTitles
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    var categoryTitles:[String]{
        get{
          return categoryArr.map { (model) -> String in
                return model.categoryName
            }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
            sectionView.leftLabel.text = "热门品牌"
            sectionView.rightDetailLabel.text = "全部\(brandsCount)个品牌"
            sectionView.rightBackView.addAction({[weak self] in
                if let strongSelf = self{
                    let brandVC = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandListController)) as! WOWBrandListController
                    strongSelf.navigationController?.pushViewController(brandVC, animated: true)
                }
                })
            return sectionView
        }else{
            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
            sectionView.leftLabel.text = "商品分类"
            sectionView.rightBackView.hidden = true
            return sectionView
        }
    }
}


