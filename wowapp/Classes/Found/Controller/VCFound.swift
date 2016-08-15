import UIKit
import SnapKit
//import FlexboxLayout

class VCFound: WOWBaseViewController {
    
    let cellID1              = String( WOWFoundWeeklyNewCell )
    let cellID2              = String( WOWFoundRecommendCell )
    let cellID3              = String( WOWFoundCategoryCell )

    let cell3_height         = CGFloat(400)
    
    var vo_products          = [WOWFoundProductModel]()
    var vo_recommend_product:WOWFoundProductModel?
    var vo_categories        = [WOWCategoryModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try request_with_throw()
        }catch{
            DLog(error)
        }
        
    }
    
    func request_with_throw() throws -> Void {
        
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_Main, successClosure: {[weak self] (result) in
                if let strongSelf = self{
                    
                        let r                             =  JSON(result)
                        strongSelf.vo_products            =  Mapper<WOWFoundProductModel>().mapArray(r["pageNewProductVoList"].arrayObject) ?? [WOWFoundProductModel]()
                        strongSelf.vo_recommend_product   =  Mapper<WOWFoundProductModel>().map( r["recommendProduct"].object )
                        //还要请求一次分类 在加载数据 以后改成rxswift 2者合并 现在代码真糟糕
                    
                        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_2nd, successClosure: {[weak self] (result) in
                            if let strongSelf = self{
                                
                                let r                             =  JSON(result)
                                strongSelf.vo_categories          =  Mapper<WOWCategoryModel>().mapArray(r["pageCategoryVoList"].arrayObject) ?? [WOWCategoryModel]()
                                
                                strongSelf.tableView.reloadData()
                                
                            }
                            
                        }){ (errorMsg) in
                            print(errorMsg)
                        }
                 
                }
                
            }){ (errorMsg) in
                print(errorMsg)
            }
      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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

//        tableView.userInteractionEnabled = false
//        tableView.allowsSelection   = false
        
        tableView.mj_header          = mj_header
        tableView.clearRestCell()
        configBarItem()
    }
    
    private func configBarItem(){
        
//        makeCustomerImageNavigationItem("search", left:true) {[weak self] () -> () in
//            if let strongSelf = self{
//                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            }
//        }

        makeCustomerImageNavigationItem("buy", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension VCFound : UITableViewDataSource,UITableViewDelegate,
FoundWeeklyNewCellDelegate,
WOWFoundRecommendCellDelegate,
WOWFoundCategoryCellDelegate
{
	
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1){
            toVCProduct(   vo_recommend_product?.productId         )
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 210
        case 2:
            return cell3_height
        default:
            return 180
            
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.whiteColor()
        
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor             = UIColor.blackColor()
        headerView.textLabel!.font                  = UIFont.systemFontOfSize(14)

    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if  ( section == 2) {return 0}
        return 15
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section {
        case 0:
            return "本周上新"
        case 1:
            return "单品推荐"
        case 2:
            return "全部分类"
        default:
            return "全部分类"

        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        return nil
//    }

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
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            if let data  = vo_recommend_product {
                cell.assign_val(data)
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
            toVCCategory(cid)
        }
      
     }

}

