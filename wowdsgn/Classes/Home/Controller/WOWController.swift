
//
//  WOWController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
struct HomeCellType {
    
    static let cell_101      = "HomeBrannerCell" // 首页轮播 cell
    
    static let cell_201      = "WOWlListCell" // 首页单个图片cell
    
    static let cell_601      = "WOWHomeFormCell" // 首页左右滑动 产品列表cell
    
    static let cell_701      = "WOWHotStyleCell" // 精选页 cell
    
    static let cell_103      = "Cell_103_Product" // 今日单品 倒计时cell
    
    static let cell_102      = "Cell_102_Project" // 专题列表 cell
    
    static let cell_402      = "HomeBottomCell" // 自定义产品组 cell
    
    static let cell_HomeList = "HomeBottomCell"// 底部列表
    
}

class WOWController: WOWBaseModuleVC {
    let cellID = String(describing: WOWlListCell.self)
    
    var dataArr = [WOWHomeModle]()    //顶部商品列表数组
    var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    
    var bottomListArray = [WOWProductModel]() //底部列表数组
    
    var singProductArray = [WOWHomeModle]() // 今日单品 倒计时的产品 数组
    
    var bottomListCount :Int = 0//底部列表数组的个数
    
    var record_402_index = [Int]()// 记录tape 为402 的下标，方便刷新数组里的喜欢状态
    
    var isOverBottomData :Bool? //底部列表数据是否拿到全部
    
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮
    
    var myQueueTimer: DispatchQueue?
    var myTimer: DispatchSourceTimer?
    
      @IBOutlet var dataDelegate: WOWTableDelegate?
    
    @IBOutlet var tableView: UITableView!
    //    var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        setUI()
        addObserver()
        self.view.addSubview(self.topBtn)
        
        self.topBtn.snp.makeConstraints { (make) in
            make.width.equalTo(98)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
        }
        self.topBtn.isHidden = true
        
        request()
        // 检查更新 
//        WOWCheckUpdate.checkUpdateWithDevice {[weak self] (isUpdate) in
//            if let strongSelf = self{
//                if isUpdate ?? false {
//                    
//                    strongSelf.goToUpdateVersion()
//                }
//            }
//        }
//
    }
    func goToUpdateVersion()  {
        let alert = UIAlertController(title: "提示", message: "版本有更新", preferredStyle: .alert)
        
        let action_sure = UIAlertAction(title: "更新", style: .default) { (action) in
            let url = NSURL(string: "https://itunes.apple.com/us/app/jian-jiao-she-ji-sheng-huo/id1110300308?mt=8")
            UIApplication.shared.openURL(url! as URL)

        }
        let action_cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action_sure)
        alert.addAction(action_cancel)
        
        present(alert, animated: true, completion: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        hidingNavBarManager?.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //FIXME:为了让动画出现 所以多reload一次咯
        //        tableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
              self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        YYWebImageManager.shared().cache?.memoryCache.removeAllObjects()

    }
    
    //MARK:Lazy
    lazy var appdelegate:AppDelegate = {
        let a =  UIApplication.shared.delegate as! AppDelegate
        return a
    }()
    
    //MARK:Lazy
    lazy var topBtn:UIButton = {
        var btn = UIButton(type: UIButtonType.custom)
        btn = btn as UIButton
        btn.setBackgroundImage(UIImage(named: "backTop"), for: UIControlState())
        btn.addTarget(self, action:#selector(backTop), for:.touchUpInside)
        return btn
    }()
    func backTop()  {
        let index = IndexPath.init(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.none, animated: true)
    }
    
    func loginSuccess()  {// 重新刷新数据
        self.pageIndex = 1
        request()
    }
    func exitLogin()  {// 重新刷新数据
        request()
    }

    fileprivate func addObserver(){
        /**
         添加通知
         */
        NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {

        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            bottomListArray.ergodicArrayWithProductModel(dic: send_obj)

            for j in record_402_index { // 遍历自定义产品列表，确保刷新喜欢状态
                let model = dataArr[j] 
                model.moduleContentProduct?.products?.ergodicArrayWithProductModel(dic: send_obj)
            }
            self.tableView.reloadData()
        }
      
    }
      lazy var mj_footerHome:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadBottomData))
        return f!
    }()
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configTableView()
        configBarItem()
//        addObserver()
    }
    func configTableView() {
        
        dataDelegate?.vc = self
        dataDelegate?.tableView = tableView
        

        
        tableView.mj_header = mj_header
        tableView.mj_footer = mj_footerHome
        
        self.tableView.backgroundColor = GrayColorLevel5

    }
    fileprivate func configBarItem(){
        configBuyBarItem() // 购物车数量
    }
    
    //MARK:Actions
    func jsClick() -> Void {
        toVCCategory(10,cname: "客厅与卧室")
    }
    func dgClick() -> Void {
        toVCCategory(15,cname: "照明")
        
    }
    func zdClick() -> Void {
        toVCCategory(16,cname: "家装配饰")
        
    }
    func sjClick() -> Void {
        toVCCategory(11,cname: "厨房")
        
    }
    //  // 移除 cell for row 里面不存在的cellType类型，防止新版本增加新类型时，出现布局错误
    func screenConfigModule() {
        for model in self.dataArr {
            switch model.moduleType ?? 0 {
            case 201,601,101,102,801,402:
                break
            default:
               
                self.dataArr.removeObject(model)
            }
        }
    }

    //MARK:Private Networkr
    override func request() {
        
        super.request()
        self.requestTop()
        self.requestBottom()
            
    }

    override func timerCount(array: Array<WOWHomeModle>){
        myQueueTimer = DispatchQueue(label: "myQueueTimer")
        myTimer = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer!)
        myTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer?.setEventHandler {
            for model in array {
                if model.moduleType == 801 {
                    for product in  (model.moduleContentProduct?.products) ?? [] {
                        if product.timeoutSeconds > 0{
                            product.timeoutSeconds  = product.timeoutSeconds - 1
                        }
                    }
                }
            }
        }
        myTimer?.resume()

    }
    // 模拟测试数据
    func testData(i: Int){
        for model in self.singProductArray {
            if model.moduleType == 801 {
                for product in  (model.moduleContentProduct?.products) ?? [] {
                    for _ in 0..<i{
                        model.moduleContentProduct?.products?.append(product)
                    }
                }
            }
        }

    }
    func requestTop() {
        let params = ["pageId": 1, "region": 1]
       
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                
                strongSelf.dataDelegate?.dataSourceArray    =    strongSelf.data(result: result)
                
                strongSelf.dataArr =  (strongSelf.dataDelegate?.dataSourceArray)!
                strongSelf.screenConfigModule() // 移除非本版本 上线的  模块类型

                if strongSelf.bottomListArray.count > 0 {// 确保reloadData 数据都存在

                    strongSelf.tableView.reloadData()
                    WOWHud.dismiss()
                }
               
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
    }
    
    func requestBottom()  {
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
                    strongSelf.bottomListCount = strongSelf.bottomListArray.count
                }else {
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.bottomListArray = []
                    }
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
                if strongSelf.dataArr.count > 0 {// 确保reloadData 数据都存在
                    
                    strongSelf.tableView.reloadData()
                     WOWHud.dismiss()
                }

                //                dispatch_group_leave(strongSelf.group);
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    func loadBottomData()  {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        requestBottom()
        
    }
  

  }
extension Array{
    // 遍历数组里面的WOWProductModel来改变 喜欢 状态。使用时，Array数据源Model必须为WOWProductModel
    func ergodicArrayWithProductModel(dic: [String:AnyObject] ){
        DispatchQueue.global().async {
            
            for a in 0..<self.count{// 遍历数据，拿到productId model 更改favorite 状态
                let model = self[a] as? WOWProductModel
                
                if model?.productId! == dic["productId"] as? Int {
                    model?.favorite = dic["favorite"] as? Bool
                }
            }
        }
      
    }
}
