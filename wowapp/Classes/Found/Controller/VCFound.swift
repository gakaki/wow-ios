import UIKit
import SnapKit
//import FlexboxLayout

class VCFound: VCBaseVCCategoryFound {
    
    let cellID0              = String( WOWFoundCategoryNewCell )
    let cellID1              = String( WOWFoundWeeklyNewCell )
    let cellID2              = String( WOWFoundRecommendCell )
    let cellID3              = String( WOWFoundCategoryCell )
    
    let cell3_height         = CGFloat(MGScreenWidth / 3 - 10 )*4
    
    var vo_products          = [WOWFoundProductModel]()
    var vo_recommend_product:WOWFoundProductModel?
    var vo_categories        = [WOWCategoryModel]()
    
    var isFavorite: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        do {
            try request_with_throw()
        }catch{
            DLog(error)
        }
        
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        do {
            try request_with_throw()
        }catch{
            DLog(error)
        }
    }
    
    func request_with_throw() throws -> Void {
            super.request()
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_Main, successClosure: {[weak self] (result) in
                if let strongSelf = self{
                    
                        let r                             =  JSON(result)
                        strongSelf.vo_products            =  Mapper<WOWFoundProductModel>().mapArray(r["pageNewProductVoList"].arrayObject) ?? [WOWFoundProductModel]()
                        strongSelf.vo_recommend_product   =  Mapper<WOWFoundProductModel>().map( r["recommendProduct"].object )
                        if (WOWUserManager.loginStatus){
                            strongSelf.requestIsFavoriteProduct()
                        }
                    
                        //还要请求一次分类 在加载数据 以后改成rxswift 2者合并 现在代码真糟糕
                    
                        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_2nd, successClosure: {[weak self] (result) in
                            if let strongSelf = self{
                                
                                let r                             =  JSON(result)
                                strongSelf.vo_categories          =  Mapper<WOWCategoryModel>().mapArray(r["pageCategoryVoList"].arrayObject) ?? [WOWCategoryModel]()
                                
                                strongSelf.tableView.reloadData()
                                strongSelf.endRefresh()

                            }
                            
                        }){ (errorMsg) in
                            print(errorMsg)
                            strongSelf.endRefresh()
                        }
                 
                }
                
            }){ (errorMsg) in
                print(errorMsg)
                self.endRefresh()

            }
      
    }
    
    //用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_IsFavoriteProduct(productId: vo_recommend_product?.productId ?? 0), successClosure: {[weak self] (result) in
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
    override func setUI() {
        super.setUI()
    
       
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.separatorColor     = SeprateColor;
        tableView.registerNib(UINib.nibName(String(WOWFoundWeeklyNewCell)), forCellReuseIdentifier:cellID1)
        tableView.registerClass(WOWFoundRecommendCell.self, forCellReuseIdentifier:cellID2)
        tableView.registerClass(WOWFoundCategoryCell.self, forCellReuseIdentifier:cellID3)
        tableView.separatorStyle     = .None
        tableView.mj_header          = mj_header
        self.edgesForExtendedLayout  = .None
        
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
        case 1:
            t           = "单品推荐"
        case 2:
            t           = "全部分类"
        default:
            t           = "本周上新"
        }
        l.text          = t

        header.addSubview(grayView)
        header.addSubview(l)
     
        return header
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 65.h
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row     = indexPath.row
        
        if ( section == 0 && row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1 , forIndexPath: indexPath) as! WOWFoundWeeklyNewCell
            cell.products = self.vo_products
            cell.delegate = self
            cell.selectionStyle = .None
            cell.bringSubviewToFront(cell.collectionView)
            return cell
        }
        else if ( section == 1 && row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2 , forIndexPath: indexPath) as! WOWFoundRecommendCell
            cell.delegate       = self
            cell.selectionStyle = .None
            
            if let data  = vo_recommend_product {
                cell.assign_val(data)
                cell.btnLike.selected = isFavorite
            }
            
            cell.bringSubviewToFront(cell.product_view)

            return cell
        }
        else if ( section == 2 && row == 0){
            
            let cell            = tableView.dequeueReusableCellWithIdentifier(cellID3 , forIndexPath: indexPath) as! WOWFoundCategoryCell
            cell.delegate       = self
            cell.frame          = CGRectMake(0, 0, MGScreenWidth, cell3_height)
            cell.setUI()
            cell.selectionStyle = .None
            cell.categories     = self.vo_categories
            return cell
        
        }else{
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


