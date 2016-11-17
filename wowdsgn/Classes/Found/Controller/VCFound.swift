import UIKit
import SnapKit
//import FlexboxLayout
import RxSwift
import RxCocoa
import RxDataSources


class VCFound: WOWBaseModuleVC {
    var dataArr = [WOWHomeModle]()    //顶部商品列表数组
    var dataMainArr                    = [WowModulePageVO]()
  
    @IBOutlet var dataDelegate: WOWTableDelegate?

    
    var myQueueTimer: DispatchQueue?
    var myTimer: DispatchSourceTimer?
    
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
        
        dataDelegate?.vc = self
        dataDelegate?.tableView = tableView
        tableView.separatorColor     = SeprateColor
        tableView.mj_header          = mj_header
        self.edgesForExtendedLayout  = UIRectEdge()

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
                strongSelf.dataDelegate?.dataSourceArray    =    strongSelf.data(result: result)
                strongSelf.dataArr  = []
                if let dataSource  = strongSelf.dataDelegate?.dataSourceArray{
                        strongSelf.dataArr = dataSource
                }
               
                strongSelf.tableView.reloadData()
            }
            
        }){ (errorMsg) in
            print(errorMsg ?? "")
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
//strongSelf.dataDelegate?.dataSourceArray
        for a in 0 ..< self.dataArr.count{
            let model = self.dataArr[a]
            if model.moduleType == 501 {
                
                if  let send_obj =  sender.object as? [String:AnyObject] {
                        model.moduleContentItem?.favorite = send_obj["favorite"] as? Bool
                }
            }
            if model.moduleType == 402 {
                if  let send_obj =  sender.object as? [String:AnyObject] {
                    
                    model.moduleContentProduct?.products?.ergodicArrayWithProductModel(dic: send_obj)
            
                    break
                }
                break
            }
        }
        tableView.reloadData()
    }
    //MARK:Actions
    func exitLogin() {
        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
            self.endRefresh()
        }

    }
    
    func loginSuccess(){
        do {
            try request_module_page_with_throw()
        }catch{
            DLog(error)
            self.endRefresh()
        }

    }

}



