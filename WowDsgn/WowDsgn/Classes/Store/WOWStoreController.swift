//
//  WOWStoreController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWStoreController: WOWBaseViewController {
    let cellID1     = String(WOWStoreBrandCell)
    let cellID2     = String(WOWMenuCell)
    var categoryArr = [WOWCategoryModel]()
    var brandArr    = [WOWBrandListModel]()
    var recommenArr = [WOWProductModel]()
    var cycleView:CyclePictureView!
    var brandsCount : Int = 0
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
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
        tableView.separatorColor = SeprateColor;
        tableView.registerNib(UINib.nibName(String(WOWStoreBrandCell)), forCellReuseIdentifier:cellID1)
        tableView.clearRestCell()
        /*
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth * 215/375), imageURLArray: nil)
        cycleView.delegate = self
        cycleView.placeholderImage = UIImage(named: "placeholder_banner")
        tableView.tableHeaderView = cycleView
         */
        tableView.mj_header = mj_header
    }
    /*
    private func configHeaderView(){
        cycleView.imageURLArray = bannerArr.map({ (model) -> String in
            return model.imageUrl ?? ""
        })
    }
    */
//MARK:Actions


//MARK:Private Network
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_StoreHome, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                strongSelf.categoryArr = []
                strongSelf.brandArr    = []
                strongSelf.recommenArr = []
                strongSelf.brandsCount = JSON(result)["brands_count"].intValue
                let brands = Mapper<WOWBrandListModel>().mapArray(JSON(result)["brands"].arrayObject)
                if let brandArray = brands{
                    strongSelf.brandArr.appendContentsOf(brandArray)
                }
                let products = Mapper<WOWProductModel>().mapArray(JSON(result)["products"].arrayObject)
                if let productArr = products{
                    strongSelf.recommenArr.appendContentsOf(productArr)
                }
                let cates = Mapper<WOWCategoryModel>().mapArray(JSON(result)["cats"].arrayObject)
                if let cateArr = cates{
                    strongSelf.categoryArr.appendContentsOf(cateArr)
                }
                strongSelf.endRefresh()
                strongSelf.tableView.reloadData()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
}

 
extension WOWStoreController:BrandCellDelegate{
    func hotBrandCellClick(brandModel: WOWBrandListModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = brandModel.brandID
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func recommenProductCellClick(productModel: WOWProductModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        vc.productID = productModel.productID
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWStoreController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2:
            return 1
        default:
             return categoryArr.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell : UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
            cell.showBrand = false
            cell.productArr = self.recommenArr
            cell.delegate = self
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2, forIndexPath: indexPath) as! WOWMenuCell
            cell.showDataModel(categoryArr[indexPath.row],isStore:true)
            returnCell = cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
            cell.showBrand = true
            cell.brandDataArr = self.brandArr
            cell.delegate = self
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 50
        }else{
            return self.view.w
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let item = categoryArr[indexPath.row]
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
            vc.categoryIndex            =   indexPath.row
            vc.categoryTitles           =   categoryTitles
            vc.categoryID               =   item.categoryID
            vc.categoryArr              =   categoryArr
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            break
        default:
            break
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
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return configSectionHeader("推荐商品")
        case 1:
            return configSectionHeader("商品分类")
        case 2:
            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
            sectionView.leftLabel.text = "热门品牌"
//            sectionView.rightDetailLabel.text = "全部\(brandsCount)个品牌"
            sectionView.rightDetailLabel.text = ""
            sectionView.rightArrowButton.hidden = true
//            sectionView.rightBackView.addAction({[weak self] in
//                if let strongSelf = self{
//                    let brandVC = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandListController)) as! WOWBrandListController
//                    strongSelf.navigationController?.pushViewController(brandVC, animated: true)
//                }
//                })
            return sectionView
        default:
            break
        }
        return nil
    }
    
    private func configSectionHeader(title:String) -> WOWStoreSectionView{
        let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
        sectionView.leftLabel.text = title
        sectionView.rightBackView.hidden = true
        return sectionView
    }
}


