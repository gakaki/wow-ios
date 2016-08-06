import UIKit
import SnapKit

class VCFound: WOWBaseViewController {
    
    let cellID1              = String( WOWFoundWeeklyNewCell )
    let cellID2              = String( WOWFoundRecommendCell )
    let cellID3              = String( WOWFoundCategoryCell )

    var vo_products          = [WOWFoundWeeklyNewModel]()
    var vo_recommend_product = []//WOWFoundRecommendModel()
    var vo_categories        = [WOWFoundCategoryModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    
    override func request(){
        
//            super.request()
//            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_Main, successClosure: {[weak self] (result) in
//                if let strongSelf = self{
//                    let arr = Mapper<WOWAddressListModel>().mapArray(JSON(result)["shippingInfoResultList"].arrayObject)
//                    if let array = arr{
//                        strongSelf.vo_products = []
////                        strongSelf.vo_products.appendContentsOf(array)
//                        strongSelf.tableView.reloadData()
//                    }
//                }
//            }) { (errorMsg) in
//                
//            }
      
        
   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUI() {
        super.setUI()
    
       
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorColor     = SeprateColor;
        tableView.registerNib(UINib.nibName(String(WOWFoundWeeklyNewCell)), forCellReuseIdentifier:cellID1)

        tableView.mj_header          = mj_header
        
        configBarItem()
    }
    
    private func configBarItem(){
        
        makeCustomerImageNavigationItem("search", left:true) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }

        makeCustomerImageNavigationItem("cart", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension VCFound : UITableViewDataSource,UITableViewDelegate {
	
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch indexPath.section {
        case 1:
            return 150
        case 2:
            return 300
        case 3:
            return 700
        default:
            return 200
            
        }
    }
    
    
    
 
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.whiteColor()
        
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.blackColor()
        headerView.textLabel!.font = UIFont(name: "systemFont", size: 14)

    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row  {
        case 0:
            return UITableViewCell()
        case 1:
            return UITableViewCell()
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
            
        }
    }
	    
}

