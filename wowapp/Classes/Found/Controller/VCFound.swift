import UIKit
import SnapKit
import FlexboxLayout

class VCFound: WOWBaseViewController {
    
    let cellID1              = String( WOWFoundWeeklyNewCell )
    let cellID2              = String( WOWFoundRecommendCell )
    let cellID3              = String( WOWFoundCategoryCell )

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
                        strongSelf.vo_products            =  Mapper<WOWFoundProductModel>().mapArray(r["pageNewProductVoList"].arrayObject)!
                        strongSelf.vo_recommend_product   =  Mapper<WOWFoundProductModel>().map( r["recommendProduct"].dictionaryObject )
                        //还要请求一次分类 在加载数据 以后改成rxswift 2者合并 现在代码真糟糕
                    
                        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Found_2nd, successClosure: {[weak self] (result) in
                            if let strongSelf = self{
                                
                                let r                             =  JSON(result)
                                strongSelf.vo_categories          =  Mapper<WOWCategoryModel>().mapArray(r["pageCategoryVoList"].arrayObject)!
                                
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
        tableView.estimatedRowHeight = 200
        tableView.separatorColor     = SeprateColor;
        tableView.registerNib(UINib.nibName(String(WOWFoundWeeklyNewCell)), forCellReuseIdentifier:cellID1)
        tableView.registerClass(WOWFoundRecommendCell.self, forCellReuseIdentifier:cellID2)
        tableView.registerNib(UINib.nibName(String(WOWFoundCategoryCell)), forCellReuseIdentifier:cellID3)

//        tableView.userInteractionEnabled = false
//        tableView.allowsSelection   = false
        
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

        makeCustomerImageNavigationItem("store_buyCar", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension VCFound : UITableViewDataSource,UITableViewDelegate,FoundWeeklyNewCellDelegate,WOWFoundRecommendCellDelegate{
	
//MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 300
        case 2:
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
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
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
            
            cell.delegate = self
            cell.selectionStyle = .None
            
//            cell.bringSubviewToFront(cell.product_view)
            
            if let data  = vo_recommend_product {
                cell.assign_val(data)
            }
            return cell
        }
        else if ( section == 2 && row == 0){
            return UITableViewCell()
        }
        
        return UITableViewCell()

    }
    func cellTouchInside(m:WOWFoundProductModel)
    {
        print(m.productId)
//        self.pushVC(vc:)
    }
    
}

