import UIKit
import SnapKit
//import FlexboxLayout
import RxSwift
import RxCocoa
import RxDataSources




class VCFound: VCBaseVCCategoryFound {
    
    var data                    = [WowModulePageVO]()
    let cell3_height            = CGFloat(MGScreenWidth / 3 - 10 )*4
    var isFavorite: Bool        = false
    var vo_recommend_product_id = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.separatorColor     = SeprateColor;

        
        tableView.separatorStyle     = .None
        tableView.mj_header          = mj_header
        self.edgesForExtendedLayout  = .None
        
        registerCell()
    }

    func registerCell(){
        for (k,c) in ModulePageType.d {
            if c is ModuleViewElement.Type {
                let cell            = (c as! ModuleViewElement.Type)
                let isNib           = cell.isNib()
                let cellName        = String(cell)
                let identifier      = "\(k)"
                if (isNib == true){
                    tableView.registerNib(UINib.nibName(cellName), forCellReuseIdentifier:identifier)
                }else{
                    tableView.registerClass(c.self, forCellReuseIdentifier:identifier)
                }
                print("\(k) = \(c)")
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
        }
    }
    
    func request_module_page_with_throw() throws -> Void {
        
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Module_Page2, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                var r                             =  JSON(result)
                strongSelf.data                   =  Mapper<WowModulePageVO>().mapArray(r["modules"].arrayObject) ?? [WowModulePageVO]()
                
                for  t:WowModulePageVO in strongSelf.data
                {
                    if t.moduleType == 302
                    {
                        if let s  = t.contentTmp!["categories"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(s) ?? [WowModulePageItemVO]()
                        }
                    }
                    if t.moduleType == 401
                    {
                        if let s  = t.contentTmp!["products"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(s) ?? [WowModulePageItemVO]()
                        }
                    }
                    if t.moduleType == 201
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(s)
                        }
                    }
                    if t.moduleType == 501
                    {
                        if let s  = t.contentTmp  {
                            t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(s)
                        }
                    }
                    if t.moduleType == 301
                    {
                        if let s  = t.contentTmp!["categories"] as? [AnyObject] {
                            t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(s) ?? [WowModulePageItemVO]()
                        }
                    }
                    
                    t.moduleClassName     =  ModulePageType.getIdentifier(t.moduleType!)
                }
                
                if (WOWUserManager.loginStatus){
                    strongSelf.requestIsFavoriteProduct()
                }
                
                
                strongSelf.data = strongSelf.data.filter({
                    $0.moduleType != 201 //201 单条banner的去掉
                })

                
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
            
        }){ (errorMsg) in
            print(errorMsg)
            self.endRefresh()
            
        }
    }
    
    //用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_IsFavoriteProduct(productId: vo_recommend_product_id ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.isFavorite = favorite ?? false
                let secction = NSIndexSet(index: 1)
                strongSelf.tableView.reloadSections(secction, withRowAnimation: .None)
            }
        }) {(errorMsg) in
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addObserver()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(loginSuccess), name:WOWLoginSuccessNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(exitLogin), name:WOWExitLoginNotificationKey, object:nil)
        
    }
    //MARK:Actions
    func exitLogin() {
        isFavorite = false
        let secction = NSIndexSet(index: 1)
        tableView.reloadSections(secction, withRowAnimation: .None)
    }
    
    func loginSuccess(){
        requestIsFavoriteProduct()
    }

}


extension VCFound : UITableViewDataSource,UITableViewDelegate,
WOWFoundRecommendCellDelegate,
FoundWeeklyNewCellDelegate,

WOWFoundCategoryCellDelegate
{
	
//MARK: UITableViewDelegate
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if(indexPath.section == 1){
//            toVCProduct(   vo_recommend_product?.productId         )
//        }
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 130.h
        case 1:
            return 180.w
        case 2:
            return cell3_height
        default:
            return 180
            
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame                   = CGRectMake(0, 0, tableView.frame.size.width, 65.h)
        let header                  = UIView(frame: frame)
        header.backgroundColor      = UIColor.whiteColor()
        
        let grayView                = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 15.h))
        grayView.backgroundColor    = MGRgb(245, g: 245, b: 245)
        
        let l                       = UILabel(frame: CGRectMake(15.w, 15.h, 200.w, 50.h))
        
        l.textAlignment = .Left
        l.lineBreakMode = .ByWordWrapping
        l.numberOfLines = 0
        l.setLineHeightAndLineBreak(1.25)
        l.textColor     = UIColor.blackColor()
        l.font          = UIFont.systemScaleFontSize(14)

        var t           = "本周上新"
        switch section {
        case 0:
            t           = ""
        case 1:
            t           = "本周上新"
        case 2:
            t           = "单品推荐"
        case 2:
            t           = "场景"
        default:
            t           = "本周上新"
        }
        l.text          = t

        header.addSubview(grayView)
        if ( l.text != ""){ //第一个不加文字显示
            header.addSubview(l)
        }
        
        return header
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 65.h
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section     = indexPath.section
        let row         = indexPath.row
        let d           = self.data[section]
        let identifier  = "\(d.moduleType!)"
        
        if ( section == 0   && row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier( identifier , forIndexPath: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302
            cell.setData( d.moduleContentArr! )
//            cell.delegate = self
            cell.selectionStyle = .None
            cell.bringSubviewToFront(cell.cv)
            return cell
        }
//        if ( section == 0   && row == 0){
//            let cell = tableView.dequeueReusableCellWithIdentifier( identifier , forIndexPath: indexPath) as! WOWFoundWeeklyNewCell
//            cell.products = self.vo_products
//            cell.delegate = self
//            cell.selectionStyle = .None
//            cell.bringSubviewToFront(cell.collectionView)
//            return cell
//        }
//        else if ( section == 1 && row == 0){
//            let cell = tableView.dequeueReusableCellWithIdentifier( identifier , forIndexPath: indexPath) as! WOWFoundRecommendCell
//            cell.delegate       = self
//            cell.selectionStyle = .None
//            
//            if let data  = vo_recommend_product {
//                cell.assign_val(data)
//                cell.btnLike.selected = isFavorite
//            }
//            
//            cell.bringSubviewToFront(cell.product_view)
//
//            return cell
//        }
//        else if ( section == 2 && row == 0){
//            
//            let cell            = tableView.dequeueReusableCellWithIdentifier( identifier , forIndexPath: indexPath) as! WOWFoundCategoryCell
//            cell.delegate       = self
//            cell.frame          = CGRectMake(0, 0, MGScreenWidth, cell3_height)
//            cell.setUI()
//            cell.selectionStyle = .None
//            cell.categories     = self.vo_categories
//            return cell
//        
//        }
//            
//        else if ( section == 3 && row == 0){
//            
//            let cell            = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! WOWFoundCategoryCell
//            cell.delegate       = self
//            cell.frame          = CGRectMake(0, 0, MGScreenWidth, cell3_height)
//            cell.setUI()
//            cell.selectionStyle = .None
//            cell.categories     = self.vo_categories
//            return cell
//            
//        }
//        
//            
//        else if ( section == 4 && row == 0){
//            
//            let cell            = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! WOWFoundCategoryCell
//            cell.delegate       = self
//            cell.frame          = CGRectMake(0, 0, MGScreenWidth, cell3_height)
//            cell.setUI()
//            cell.selectionStyle = .None
//            cell.categories     = self.vo_categories
//            return cell
//        }
        else{
            return UITableViewCell()
        }
    }
    
    
    func cellTouchInside(m:WOWFoundProductModel)
    {
        print(m.productId as Int?)
        
        if let pid = m.productId as Int? {
            self.toVCProduct(pid)
        }
        
    }
    
    
    func foundCategorycellTouchInside(m:WOWCategoryModel)
    {
        if let cid = m.categoryID{
            toVCCategory(cid,cname: m.categoryName!)
        }
      
     }
    
    func notLoginThanToLogin(){
        if  (!WOWUserManager.loginStatus){
            toLoginVC(true)
        }
    }
    
    func toProductDetail(productId: Int?) {
        toVCProduct(productId)
    }

  
}


