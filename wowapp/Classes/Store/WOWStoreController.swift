//
//  WOWStoreController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWStoreController: WOWBaseViewController {
    let cellID1     = String(describing: WOWStoreBrandCell())
    let cellID2     = String(describing: WOWMenuCell())
    var categoryArr = [WOWCategoryModel]()
    var brandArr    = [WOWBrandListModel]()
    var recommenArr = [WOWProductModel]()
    var cycleView   :CyclePictureView!
    var brandsCount : Int = 0
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorColor     = SeprateColor;
        tableView.register(UINib.nibName(String(describing: WOWStoreBrandCell)), forCellReuseIdentifier:cellID1)
        tableView.clearRestCell()
        tableView.mj_header          = mj_header
        configBarItem()
    }
    
    fileprivate func configBarItem(){
        makeCustomerImageNavigationItem("search", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

    
//MARK:Actions


//MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_StoreHome, successClosure: {[weak self] (result) in
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
                let json = JSON(result)["cats"].arrayObject
                if let cats = json{
                    for item in cats{
                        let model = Mapper<WOWCategoryModel>().map(item)
                        if let m = model{
                            strongSelf.categoryArr.append(m)
                        }
                    }
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
    func hotBrandCellClick(_ brandModel: WOWBrandListModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = brandModel.brandId
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:推荐商品
    func recommenProductCellClick(_ productModel: WOWProductModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = productModel.productId
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWStoreController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,2:
            return 1
        default:
             return categoryArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : UITableViewCell!
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID1, for: indexPath) as! WOWStoreBrandCell
            cell.showBrand = false
            cell.productArr = self.recommenArr
            cell.delegate = self
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath) as! WOWMenuCell
            cell.showDataModel(categoryArr[(indexPath as NSIndexPath).row],isStore:true)
            cell.backgroundColor = UIColor.white
            returnCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID1, for: indexPath) as! WOWStoreBrandCell
            cell.showBrand = true
            cell.brandDataArr = self.brandArr
            cell.delegate = self
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 1{
            return 50
        }else{
            return self.view.w
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            break
        case 1:
            let item = categoryArr[(indexPath as NSIndexPath).row]
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
            vc.categoryIndex            =   (indexPath as NSIndexPath).row
            vc.categoryTitles           =   categoryTitles
            vc.categoryID               =   item.categoryID ?? "5"
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
                return model.categoryName ?? "全部"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 15
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame:CGRect(x: 0, y: 0, width: MGScreenWidth, height: 15))
        v.backgroundColor = UIColor.whiteColor()
        return v
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return configSectionHeader("推荐商品")
        case 1:
            return configSectionHeader("商品分类")
        case 2:
            let sectionView =  Bundle.main.loadNibNamed(String(describing: WOWStoreSectionView), owner: self, options: nil)?.last as! WOWStoreSectionView
            sectionView.leftLabel.text = "热门品牌"
            sectionView.bottomLine.isHidden = true
            sectionView.rightDetailLabel.text = "全部\(brandsCount)个品牌"
            sectionView.rightBackView.addAction({[weak self] in
                if let strongSelf = self{
                    let brandVC = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandListController)) as! WOWBrandListController
                    strongSelf.navigationController?.pushViewController(brandVC, animated: true)
                }
                })
            return sectionView
        default:
            break
        }
        return nil
    }
    
    fileprivate func configSectionHeader(_ title:String) -> WOWStoreSectionView{
        let sectionView =  Bundle.main.loadNibNamed(String(describing: WOWStoreSectionView), owner: self, options: nil)?.last as! WOWStoreSectionView
        sectionView.leftLabel.text = title
        sectionView.rightBackView.isHidden = true
        return sectionView
    }
}


