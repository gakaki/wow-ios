import UIKit
import SnapKit
//import FlexboxLayout
import RxSwift
import RxCocoa
import RxDataSources


class VCFound: WOWBaseModuleVC {
    var dataArr = [WOWHomeModle]()    //顶部商品列表数组
    var dataMainArr                    = [WowModulePageVO]()
    var bottomListArray = [WOWProductModel]() //底部列表数组
    
    var record_402_index = [Int]()// 记录tape 为402 的下标，方便刷新数组里的喜欢状态
    
    var isOverBottomData :Bool? //底部列表数据是否拿到全部
        
    var myQueueTimer: DispatchQueue?
    var myTimer: DispatchSourceTimer?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        do {
            try request_module_page_with_throw()
//                requestBottom()
        }catch{
            DLog(error)
            self.endRefresh()
        }
        
    }
    
    override func setUI() {
        super.setUI()
        self.view.backgroundColor           = GrayColorLevel5
        
        dataDelegate?.vc                    = self
        dataDelegate?.ViewControllerType    = ControllerViewType.Home
        tableView.separatorColor            = SeprateColor
//        tableView.mj_footer                 = mj_footerHome


    }
    
//MARK: PURLL TO REFRESH AND REQUEST
    override func pullToRefresh() {
        super.pullToRefresh()
        do {
            try request_module_page_with_throw()
//                requestBottom()
        }catch{
            DLog(error)
            self.endRefresh()

        }
    }


    func request_module_page_with_throw() throws -> Void {
        
        super.request()
        let params = ["pageId": 2, "region": 1]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                strongSelf.dataDelegate?.dataSourceArray    =    strongSelf.dataWithHomeModel(result: result)
                
                strongSelf.dataArr  = []
                if let dataSource  = strongSelf.dataDelegate?.dataSourceArray{
                    strongSelf.dataArr = dataSource
                }
//                if strongSelf.bottomListArray.count > 0 {// 确保reloadData 数据都存在
                
                    strongSelf.tableView.reloadData()
                
//                }
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }
    
    override func requestBottom()  {
        var params = [String: AnyObject]()
        
        let totalPage = 10
        params = ["excludes": [] as AnyObject ,"currentPage": pageIndex as AnyObject,"pageSize":totalPage as AnyObject]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_BottomList(params : params), successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.mj_footerHome.endRefreshing()
                
                let bannerList = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.bottomListArray = []
                        strongSelf.dataDelegate?.isOverBottomData = false
                        
                    }
                    if bannerList.count < totalPage {// 如果拿到的数据，小于分页，则说明，无下一页
                        strongSelf.tableView.mj_footer = nil
                        strongSelf.dataDelegate?.isOverBottomData = true
                        
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footerHome
                    }
                    
                    strongSelf.bottomListArray.append(contentsOf: bannerList)
                    strongSelf.dataDelegate?.bottomListArray = strongSelf.bottomListArray
                    
                }else {
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.bottomListArray = []
                    }
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
//                if strongSelf.dataArr.count > 0 {// 确保reloadData 数据都存在
                
                    strongSelf.tableView.reloadData()
                    WOWHud.dismiss()
//                }

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
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



