import UIKit
import SnapKit
//import FlexboxLayout
import RxSwift
import RxCocoa
import RxDataSources


class VCFound: VCBaseVCCategoryFound {
    
    var data                    = [WowModulePageVO]()
    var isFavorite: Bool        = false
    var vo_recommend_product_id = 0
    var cell_heights            = [0:0.h]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
            self.endRefresh()
        }
    }
    
    override func setUI() {
        super.setUI()
        
        tableView.rowHeight          = UITableViewAutomaticDimension
        //为了防止刷新tableview上下跳动
//        tableView.estimatedRowHeight = 300
        tableView.separatorColor     = SeprateColor;

        
        tableView.separatorStyle     = .none
        tableView.mj_header          = mj_header
        self.edgesForExtendedLayout  = UIRectEdge()
        
        registerCell()
    }

    func registerCell(){
        for (k,c) in ModulePageType.d {
            if c is ModuleViewElement.Type {
                let cell            = (c as! ModuleViewElement.Type)
                let isNib           = cell.isNib()
                let cellName        = String(describing: cell)
                let identifier      = "\(k)"
                if (isNib == true){
                    tableView.register(UINib.nibName(cellName), forCellReuseIdentifier:identifier)
                }else{
                    tableView.register(c.self, forCellReuseIdentifier:identifier)
                }
                print("\(k) = \(c)")
            }
        }
        
    }
    
//MARK: PURLL TO REFRESH AND REQUEST
    override func pullToRefresh() {
        super.pullToRefresh()
        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
            self.endRefresh()

        }
    }
    
    func request_module_page_with_throw() throws -> Void {
        
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Module_Page2, successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                                
                strongSelf.endRefresh()
                
                var r                             =  JSON(result)
                strongSelf.data                   =  Mapper<WowModulePageVO>().mapArray(JSONObject:r["modules"].arrayObject) ?? [WowModulePageVO]()
                
                for  t:WowModulePageVO in strongSelf.data
                {
                    if t.moduleType == 101
                    {
                        if let s  = t.contentTmp!["banners"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                        }
                    }
                    if t.moduleType == 302
                    {
                        if let s  = t.contentTmp!["categories"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                        }
                    }
                    if t.moduleType == 401
                    {
                        if let s  = t.contentTmp!["products"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                            t.name = (t.contentTmp!["name"] as? String) ?? ""
                            
                        }
                    }
                    if t.moduleType == 201
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                        }
                    }
                    if t.moduleType == 501
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                        }
                    }
                    if t.moduleType == 301
                    {
                        if let s  = t.contentTmp!["categories"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                        }
                    }
                    if t.moduleType == 201
                    {
                        if let s  = t.contentTmp {
                            t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                        }
                    }
                    if t.moduleType == 402
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContent_402   =  Mapper<WOWHomeProduct_402_Info>().map(JSONObject:s)
                            t.moduleContent_402?.name = (t.contentTmp!["name"] as? String) ?? ""
                        }
                    }
                    if t.moduleType == 801
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContentProduct   =  Mapper<WOWHomeProduct_402_Info>().map(JSONObject:s)
                        }

                        
                    }
                    if t.moduleType == 102
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContent_102   =  Mapper<WOWCarouselBanners>().map(JSONObject:s)
                        }
                    }
                                       
                    t.moduleClassName     =  ModulePageType.getIdentifier(t.moduleType!)
                }
                
                if (WOWUserManager.loginStatus){
                    strongSelf.requestIsFavoriteProduct()
                }
                
                
                strongSelf.tableView.reloadData()
            }
            
        }){ (errorMsg) in
            print(errorMsg)
            self.endRefresh()
            
        }
    }
    
    //用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteProduct(productId: vo_recommend_product_id ), successClosure: {[weak self] (result, code) in
            

            if let strongSelf = self{
                strongSelf.endRefresh()
                let favorite = JSON(result)["favorite"].bool
                strongSelf.isFavorite = favorite ?? false
                strongSelf.tableView.reloadData()
//                let secction = IndexSet(integer: 1)
//                strongSelf.tableView.reloadSections(secction, with: .none)
            }
        }) {(errorMsg) in
            self.endRefresh()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    fileprivate func addObserver(){
        NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    func refreshData(_ sender: Notification)  {

        guard (sender.object != nil) else{//
            return
        }

        for a in 0 ..< self.data.count {
            let model = self.data[a]
            if model.moduleType == 501 {
                
                if  let send_obj =  sender.object as? [String:AnyObject] {
                        model.moduleContentItem?.favorite = send_obj["favorite"] as? Bool
                }
            }
            if model.moduleType == 402 {
                if  let send_obj =  sender.object as? [String:AnyObject] {
                    
                    model.moduleContent_402?.products?.ergodicArrayWithProductModel(dic: send_obj)
            
                    break
                }
                break
            }
        }
        tableView.reloadData()
    }
    //MARK:Actions
    func exitLogin() {
        isFavorite = false
        let secction = IndexSet(integer: 1)
        tableView.reloadSections(secction, with: .none)
    }
    
    func loginSuccess(){
        requestIsFavoriteProduct()
    }

}


extension VCFound : UITableViewDataSource,UITableViewDelegate,
WOWFoundRecommendCellDelegate,
FoundWeeklyNewCellDelegate,
WOWFoundCategoryCellDelegate,
MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate
{
	

    func getCellHeight(_ sectionIndex:Int) -> CGFloat{
        if let h = cell_heights[sectionIndex] {
            return h
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

          return getCellHeight(indexPath.section)

    }
    func headerView(title : String,sectionIndex:Int) -> UIView? {
        
        let frame_width             = MGScreenWidth
        
        let grayView                = UIView(frame: CGRect(x: 0, y: 0, width: frame_width, height: 15.h))
        grayView.backgroundColor    = MGRgb(245, g: 245, b: 245)

        
        let l                       = UILabel(frame: CGRect(x: 15.w, y: 15.h, width: 200.w, height: 50.h))
        
        l.textAlignment = .left
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.setLineHeightAndLineBreak(1.25)
        l.textColor     = UIColor.black
        l.font          = UIFont.systemScaleFontSize(14)
        
        let t           = title
        
        l.text          = t
        
        var frame_height            = 65.h
        
        if t == "" {
            frame_height            = CGFloat.leastNormalMagnitude
            
        }
        
        let frame                   = CGRect(x: 0, y: 0, width: frame_width, height: frame_height)
        let header                  = UIView(frame: frame)
        header.backgroundColor      = UIColor.white
        header.addSubview(grayView)
        
        if t != "" {
            header.addSubview(l)
        }
        let model = self.data[sectionIndex]
        if model.moduleType == 402 {
            let lbBottom = UIView()
            lbBottom.frame = CGRect(x: 0, y: frame_height - 0.5, width: frame_width, height: 0.5)
            lbBottom.backgroundColor = UIColor.init(hexString: "EAEAEA")
            header.addSubview(lbBottom)
        }
        return header

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.data[section]
        var t           = "本周上新"
       
        switch model.moduleType ?? 0{
        case 302:
            t           = ""
        case 401:
            t           = model.name ?? "本周上新"
        case 501:
            t           = "单品推荐"
        case 301:
            t           = "场景"
        case 402:
            t           = model.moduleContent_402?.name ?? "居家好物"
        default:
            t           = ""
        }
        return self.headerView(title: t,sectionIndex: section)!
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = self.data[section]
        switch model.moduleType ?? 0{
        case 302:
             return 15.h
        case 401,501,301,402:
             return 65.h
        default:
             return 15.h
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = data[section]
        
        switch model.moduleType ?? 0 {
        case 402:

            let array = model.moduleContent_402?.products ?? []
            return (array.count.getParityCellNumber()) > 10 ? 10: (array.count.getParityCellNumber())
            
        default:
            
            return 1
            
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section     = (indexPath as NSIndexPath).section
//        let row         = indexPath.row
        let d           = self.data[section]
        let identifier  = "\(d.moduleType!)"
        
        if let cell_type   = d.moduleType {
        
            DLog("cell type is \(cell_type)")
            
            if ( cell_type == MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302.cell_type() ){
                let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302
                cell.setData( d.moduleContentArr ?? [WowModulePageItemVO]() )
                cell_heights[section] = cell.heightAll
                cell.delegate = self
                cell.selectionStyle = .none
                cell.bringSubview(toFront: cell.cv)
                return cell
            }
            else if ( cell_type == WOWFoundWeeklyNewCell.cell_type() ){
                let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! WOWFoundWeeklyNewCell
                cell.setData( d.moduleContentArr ?? [WowModulePageItemVO]())
                cell_heights[section]  = cell.heightAll
                cell.delegate = self
                cell.selectionStyle = .none
                cell.bringSubview(toFront: cell.cv)
                return cell
            }
            else if (  cell_type == MODULE_TYPE_SINGLE_BANNER_CELL_201.cell_type() ){
                
                let cell            = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! MODULE_TYPE_SINGLE_BANNER_CELL_201
                //                cell.delegate       = self
                cell.selectionStyle = .none
                cell.setData(d.moduleContentItem!)
                cell_heights[section]  = cell.heightAll
                //            print("cel height is ",cell_heights[section])
                return cell
            }
            else if ( cell_type == WOWFoundRecommendCell.cell_type() ){
                let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! WOWFoundRecommendCell
                cell.delegate       = self
                cell.selectionStyle = .none
                cell.setData( d.moduleContentItem! )
                cell_heights[section]  = cell.heightAll
                //            cell.btnLike.selected = isFavorite
                cell.bringSubview(toFront: cell.product_view)
                
                return cell
            }
            else if (  cell_type == MODULE_TYPE_CATEGORIES_CV_CELL_301.cell_type() ){
                
                let cell            = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301
                cell.delegate       = self
                cell.selectionStyle = .none
                cell.setData(d.moduleContentArr ?? [WowModulePageItemVO]())
                cell_heights[section]  = cell.heightAll
                
                //            print("cel height is ",cell_heights[section])
                cell.bringSubview(toFront: cell.collectionView)
                
                return cell
            }
            else if ( cell_type == Cell_102_Project.cell_type()) {
                let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_102_Project
                cell.dataArr = d.moduleContent_102?.banners
                cell.lbTitle.text = d.moduleContent_102?.name ?? "专题"
                cell_heights[section]  = 290
                cell.delegate = self
                cell.selectionStyle = .none
                return cell

            }
//            else if ( cell_type == Cell_103_Product.cell_type() ){
//            
//                
//                let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_103, for: indexPath) as! Cell_103_Product
////                let array = model.moduleContentProduct?.products
//                
////                cell.dataSourceArray = array
////                cell.delegate = self
//                cell_heights[section]  = 210
//                cell.selectionStyle = .none
//                return cell
//
//            }
            else if ( cell_type == HomeBottomCell.cell_type()) {
                let model = data[section]

                let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeBottomCell
                cell.indexPath = indexPath
                
                let OneCellNumber = indexPath.row * 2
                let TwoCellNumber = ((indexPath.row + 1) * 2) - 1
                let productsArray = model.moduleContent_402?.products ?? []

                var heightCell:CGFloat = 0.0
                switch UIDevice.deviceType {
                case .dt_iPhone5:
                    heightCell = 244.0
                case .dt_iPhone6_Plus:
                    heightCell = 292.0
                default:
                    heightCell = 272.0
                }
                cell_heights[section]  = heightCell
                if productsArray.count.isOdd && (indexPath as NSIndexPath).row + 1 == productsArray.count.getParityCellNumber(){ //  满足为奇数 第二个item 隐藏
                    
                    self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:productsArray)
                    
                }else{
                    
                    self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:productsArray)
                    
                }
//                // 排序 0，1，2，3，4...
                cell.delegate = self
                cell.selectionStyle = .none
                
                return cell

            }
//
            else{
                return UITableViewCell()
            }
        }
        else{
            return UITableViewCell()
        }
    }
    // 配置cell的UI
    func cellUIConfig(one: NSInteger, two: NSInteger ,isHiddenTwoItem: Bool, cell:HomeBottomCell,dataSourceArray:[WOWProductModel])  {
        let  modelOne = dataSourceArray[one]
        if isHiddenTwoItem == false {
            
            cell.showDataOne(modelOne)
            cell.twoLb.isHidden = false
            
        }else{
            
            let  modelTwo = dataSourceArray[two]
            cell.showDataOne(modelOne)
            cell.showDataTwo(modelTwo)
            cell.twoLb.isHidden = true
        }
        
        cell.oneBtn.tag = one
        cell.twoBtn.tag = two
        
    }

    
    func cellTouchInside(_ m:WOWFoundProductModel)
    {
        print(m.productId as Int?)
        
        if let pid = m.productId as Int? {
            self.toVCProduct(pid)
        }
        
    }
    
    
    func foundCategorycellTouchInside(_ m:WOWCategoryModel)
    {
        if let cid = m.categoryID?.toInt(){
            toVCCategory(cid,cname: m.categoryName!)
        }
      
     }
    
    func notLoginThanToLogin(){
        if  (!WOWUserManager.loginStatus){
            toLoginVC(true)
        }
    }
    
    func toProductDetail(_ productId: Int?) {
        toVCProduct(productId)
    }

    
    func cellFoundWeeklyNewCellTouchInside(_ m:WowModulePageItemVO){
        print(m.productId as Int?)
        
        if let pid = m.productId as Int? {
            self.toVCProduct(pid)
        }
    }
    
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(_ m:WowModulePageItemVO?)
    {
        
        if m == nil {
            toVCCategoryChoose()
        }else{
            if let cid = m!.categoryId , let cname = m!.categoryName{
                toVCCategory( cid,cname: cname)
            }
        }
        
    }
}
extension VCFound:HomeBottomDelegate{
    
    func goToProductDetailVC(_ productId: Int?) {//跳转产品详情
        
        toVCProduct(productId)
        
    }
    
}
extension VCFound:cell_102_delegate{
    func goToProjectDetailVC(_ model: WOWCarouselBanners?){
        if let model = model {
            goController(model)
        }
        
    }
    //点击跳转
    func goController(_ model: WOWCarouselBanners) {
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                let vc = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWWebViewController.self)) as! WOWWebViewController
                
                vc.bannerUrl = model.bannerLinkUrl
                navigationController?.pushViewController(vc, animated: true)
                print("web后台填连接")
            case 2:
                print("专题详情页（商品列表）")
            case 3:
                print("专题详情页（图文混排）")
            case 4:
                print("品牌详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.brandID = model.bannerLinkTargetId
                vc.entrance = .brandEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 5:
                print("设计师详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.designerId = model.bannerLinkTargetId
                vc.entrance = .designerEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                print("商品详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
                vc.hideNavigationBar = true
                vc.productId = model.bannerLinkTargetId
                navigationController?.pushViewController(vc, animated: true)
                
            case 7:
                print("分类详情页")
                
            case 8:// 专题详情
                toVCTopic(model.bannerLinkTargetId ?? 0)
                print("场景还是专题")
            case 9:// 专题详情
                
                toVCTopidDetail(model.bannerLinkTargetId ?? 0)
                
            default:
                print("其他")
            }
            
        }
        
    }

}

extension VCFound :MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate {
    func MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate_CellTouchInside(_ m:WowModulePageItemVO?)
    {
        if let cid = m!.categoryId , let cname = m!.categoryName{
            toVCCategory( cid ,cname: cname)
        }
    }
}


