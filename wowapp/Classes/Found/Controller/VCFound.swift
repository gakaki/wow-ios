

import UIKit

class VCFound: WOWBaseViewController {
    
    let cellID1              = String( WOWFoundWeeklyNewCell )
    let cellID2              = String( WOWFoundRecommendCell )
    let cellID3              = String( WOWFoundCategoryCell )

    var vo_products          = [WOWFoundWeeklyNewModel]()
    var vo_recommend_product = []//WOWFoundRecommendModel()
    var vo_categories        = [WOWFoundCategoryModel]()
    
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
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorColor     = SeprateColor;
        tableView.registerNib(UINib.nibName(String(WOWStoreBrandCell)), forCellReuseIdentifier:cellID1)
        tableView.clearRestCell()
        tableView.mj_header          = mj_header
        configBarItem()
    }
    
    private func configBarItem(){
        makeCustomerImageNavigationItem("search", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


////MARK:Actions
//
//
////MARK:Private Network
//    override func request() {
//        WOWNetManager.sharedManager.requestWithTarget(.Api_StoreHome, successClosure: {[weak self] (result) in
//            if let strongSelf = self{
//                WOWHud.dismiss()
//                strongSelf.categoryArr = []
//                strongSelf.brandArr    = []
//                strongSelf.recommenArr = []
//                strongSelf.brandsCount = JSON(result)["brands_count"].intValue
//                let brands = Mapper<WOWBrandListModel>().mapArray(JSON(result)["brands"].arrayObject)
//                if let brandArray = brands{
//                    strongSelf.brandArr.appendContentsOf(brandArray)
//                }
//                let products = Mapper<WOWProductModel>().mapArray(JSON(result)["products"].arrayObject)
//                if let productArr = products{
//                    strongSelf.recommenArr.appendContentsOf(productArr)
//                }
//                let json = JSON(result)["cats"].arrayObject
//                if let cats = json{
//                    for item in cats{
//                        let model = Mapper<WOWCategoryModel>().map(item)
//                        if let m = model{
//                            strongSelf.categoryArr.append(m)
//                        }
//                    }
//                }
//                strongSelf.endRefresh()
//                strongSelf.tableView.reloadData()
//            }
//        }) {[weak self] (errorMsg) in
//            if let strongSelf = self{
//                strongSelf.endRefresh()
//            }
//        }
//    }
//}
//
// 
//extension WOWStoreController:BrandCellDelegate{
//    func hotBrandCellClick(brandModel: WOWBrandListModel) {
//        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
//        vc.brandID = brandModel.brandID
//        vc.hideNavigationBar = true
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    //MARK:推荐商品
//    func recommenProductCellClick(productModel: WOWProductModel) {
//        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
//        vc.hideNavigationBar = true
//        vc.productID = productModel.productID
//        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//
//extension WOWStoreController:UITableViewDelegate,UITableViewDataSource{
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0,2:
//            return 1
//        default:
//             return categoryArr.count
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var returnCell : UITableViewCell!
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
//            cell.showBrand = false
//            cell.productArr = self.recommenArr
//            cell.delegate = self
//            returnCell = cell
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2, forIndexPath: indexPath) as! WOWMenuCell
//            cell.showDataModel(categoryArr[indexPath.row],isStore:true)
//            cell.backgroundColor = UIColor.whiteColor()
//            returnCell = cell
//        case 2:
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
//            cell.showBrand = true
//            cell.brandDataArr = self.brandArr
//            cell.delegate = self
//            returnCell = cell
//        default:
//            break
//        }
//        return returnCell
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.section == 1{
//            return 50
//        }else{
//            return self.view.w
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch indexPath.section {
//        case 0:
//            break
//        case 1:
//            let item = categoryArr[indexPath.row]
//            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
//            vc.categoryIndex            =   indexPath.row
//            vc.categoryTitles           =   categoryTitles
//            vc.categoryID               =   item.categoryID ?? "5"
//            vc.categoryArr              =   categoryArr
//            navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            break
//        default:
//            break
//        }
//    }
//    
//    var categoryTitles:[String]{
//        get{
//          return categoryArr.map { (model) -> String in
//                return model.categoryName ?? "全部"
//            }
//        }
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 1:
//            return 15
//        default:
//            return 0.01
//        }
//    }
//    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v = UIView(frame:CGRectMake(0, 0, MGScreenWidth, 15))
//        v.backgroundColor = UIColor.whiteColor()
//        return v
//    }
//    
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            return configSectionHeader("推荐商品")
//        case 1:
//            return configSectionHeader("商品分类")
//        case 2:
//            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
//            sectionView.leftLabel.text = "热门品牌"
//            sectionView.bottomLine.hidden = true
//            sectionView.rightDetailLabel.text = "全部\(brandsCount)个品牌"
//            sectionView.rightBackView.addAction({[weak self] in
//                if let strongSelf = self{
//                    let brandVC = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandListController)) as! WOWBrandListController
//                    strongSelf.navigationController?.pushViewController(brandVC, animated: true)
//                }
//                })
//            return sectionView
//        default:
//            break
//        }
//        return nil
//    }
//    
//    private func configSectionHeader(title:String) -> WOWStoreSectionView{
//        let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
//        sectionView.leftLabel.text = title
//        sectionView.rightBackView.hidden = true
//        return sectionView
//    }
//}

