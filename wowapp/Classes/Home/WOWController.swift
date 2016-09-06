//
//  WOWController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWController: WOWBaseViewController {
    let cellID = String(WOWlListCell)
    //    let WOWProductDetailAboutCell = String( WOWProductDetailAboutCell )
    
    var isOpen: Bool! = false
    
    var dataArr = [WOWHomeModle]()    //商品列表数组
    var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    
    var bottomListArray = [WOWFoundProductModel]() //底部列表数组
    
    var bottomListCount :Int = 0//底部列表数组的个数
    
    @IBOutlet var tableView: UITableView!
    //    var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //        self.hideNavigationBar = true
//        requestQueue()
        request()
//        requestTest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        hidingNavBarManager?.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //FIXME:为了让动画出现 所以多reload一次咯
        //        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Lazy
    lazy var appdelegate:AppDelegate = {
        let a =  UIApplication.sharedApplication().delegate as! AppDelegate
        return a
    }()
    
    
    lazy var banner:WOWBanner = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWBanner), owner: self, options: nil).last as! WOWBanner
        view.cyclePictureView.delegate = self
        view.jsButton.addTarget(self, action: #selector(jsClick), forControlEvents: .TouchUpInside)
        view.dgButton.addTarget(self, action: #selector(dgClick), forControlEvents: .TouchUpInside)
        view.zdButton.addTarget(self, action: #selector(zdClick), forControlEvents: .TouchUpInside)
        view.sjButton.addTarget(self, action: #selector(sjClick), forControlEvents: .TouchUpInside)
        return view
    }()
    
    
    
    //MARK:Private Method
    override func setUI() {
        
        tableView.registerNib(UINib.nibName(String(WOWlListCell)), forCellReuseIdentifier:cellID)
        
        tableView.registerNib(UINib.nibName("WOWHomeFormCell"), forCellReuseIdentifier: "WOWHomeFormCell")
        tableView.registerNib(UINib.nibName("HomeBottomCell"), forCellReuseIdentifier: "HomeBottomCell")
        
        tableView.registerNib(UINib.nibName("HomeBrannerCell"), forCellReuseIdentifier: "HomeBrannerCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
        
        //        configBarItem()
        tableView.mj_header = mj_header
        
        self.tableView.backgroundColor = GrayColorLevel6
        
        configBarItem()
        
    }
    
    
    private func configBarItem(){
        
        makeCustomerImageNavigationItem("search", left:true) {[weak self] () -> () in

      

            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            }

        }

        configBuyBarItem(WOWUserManager.userCarCount) // 购物车数量
    }
    
    
    
    //MARK:Actions
    func jsClick() -> Void {
        toVCCategory("10",cname: "客厅与卧室")
    }
    func dgClick() -> Void {
        toVCCategory("15",cname: "照明")
        
    }
    func zdClick() -> Void {
        toVCCategory("16",cname: "家装配饰")
        
    }
    func sjClick() -> Void {
        toVCCategory("11",cname: "厨房")
        
    }
    //MARK:Private Networkr
    override func request() {
        
        super.request()
        
        var queue: dispatch_queue_t = dispatch_get_main_queue()// 主线程
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)// 后台执行
        // 分组执行
        
        let group = dispatch_group_create()
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)// 默认优先级执行
    
            //异步执行队列任务
            dispatch_group_wait(group, 100)// 等待队列中任务完成，设置等待超时的时间
            dispatch_group_async(group, queue, { () -> Void in

                self.requestTop()
  
            })
        
            dispatch_group_async(group, queue, { () -> Void in
            
                self.requestBottom()
      
            })

        // 分组队列执行完毕后执行 由于网络请求也是异步，所以这个数据不稳定 暂时不考虑在这刷新
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
          
            print("dispatch_group_notify")
            
        }
    }
    
    func requestTop() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_List(region: 1), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                

                let bannerList = Mapper<WOWHomeModle>().mapArray(JSON(result)["modules"].arrayObject)
                
                
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray

                }
                 strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }

    func requestBottom()  {
        var params = [String: AnyObject]?()
        
        let totalPage = 10

        params = ["excludes": [], "currentPage": pageIndex,"pageSize":totalPage]

        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_BottomList(params : params), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWFoundProductModel>().mapArray(JSON(result)["productVoList"].arrayObject)
               
                if let bannerList = bannerList{
                    strongSelf.bottomListArray = []
                    strongSelf.bottomListArray = bannerList
                    strongSelf.bottomListCount = strongSelf.bottomListArray.count
                }
                strongSelf.tableView.reloadData()

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }
    
    //点击跳转
    func goController(model: WOWCarouselBanners) {
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                print("web后台填连接")
            case 2:
                print("专题详情页（商品列表）")
            case 3:
                print("专题详情页（图文混排）")
            case 4:
                print("品牌详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
                vc.brandID = model.bannerLinkTargetId
                vc.entrance = .brandEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 5:
                print("设计师详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
                vc.designerId = model.bannerLinkTargetId
                vc.entrance = .designerEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                print("商品详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
                vc.hideNavigationBar = true
                vc.productId = model.bannerLinkTargetId
                navigationController?.pushViewController(vc, animated: true)
                
            case 7:
                print("分类详情页")
                
            case 8:
                toVCTopic(model.bannerLinkTargetId!)
                print("场景还是专题")
                
                
            default:
                print("其他")
            }
            
        }
        
    }
}


extension WOWController:LeftSideProtocol{
    func sideMenuSelect(tagString: String!, index: Int,dataArr:[WOWCategoryModel]) {
        /*
         let tab = WOWTool.appTabBarController
         tab.selectedIndex = 1
         let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
         vc.categoryIndex    = index
         vc.categoryTitles   = categoryTitles
         vc.categoryID       = WOWRealm.objects(WOWCategoryModel)[index].categoryID
         vc.categoryArr      = dataArr
         let nav = tab.selectedViewController as! WOWNavigationController
         nav.pushViewController(vc, animated: true)
         */
    }
    /*
     var categoryTitles:[String]{
     get{
     let categorys = WOWRealm.objects(WOWCategoryModel)
     return categorys.map { (model) -> String in
     return model.categoryName
     }
     }
     }
     */
}

extension WOWController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return (dataArr.count ?? 0) + bottomListCount.getParityCellNumber()

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        guard indexPath.section < dataArr.count  else {
            let cell                = tableView.dequeueReusableCellWithIdentifier("HomeBottomCell", forIndexPath: indexPath) as! HomeBottomCell
            
            cell.indexPath = indexPath
            
            if bottomListCount.isOdd {
                if indexPath.section + 1 == (dataArr.count) + bottomListCount.getParityCellNumber() { // 如果奇数 满足则 第二个Item 不出现
                    
                    cell.twoLb.hidden = false
                    
                }else{
                    
                    cell.twoLb.hidden = true
                    
                }
            }else{
                cell.twoLb.hidden = true
            }
            let OneCellNumber = (indexPath.section  - dataArr.count + 0) * 2
            let TwoCellNumber = ((indexPath.section  - dataArr.count + 1) * 2) - 1
            
            let modelOne = bottomListArray[OneCellNumber]
            
            let modelTwo = bottomListArray[TwoCellNumber]
            
            cell.showDataOne(modelOne)
            cell.showDataTwo(modelTwo)
            cell.oneBtn.tag = OneCellNumber
            cell.twoBtn.tag = TwoCellNumber
            
            cell.selectionStyle = .None
            return cell
            
        }
        let model = dataArr[indexPath.section]

        if model.moduleType == 201 {
            
            let cell                = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWlListCell
            
            cell.delegate       = self
//            let model           = dataArr[indexPath.section]
            cell.showData(model.moduleContent!)
            
            cell.selectionStyle = .None
            
            return cell

        }else if model.moduleType == 601{
            
            let cell                = tableView.dequeueReusableCellWithIdentifier("WOWHomeFormCell", forIndexPath: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate = self
//            cell.mainModel = model
            
            cell.lbMainTitle.text = model.moduleContentList?.topicMainTitle
            cell.lbContent.text = model.moduleContentList?.topicDesc
            
            cell.dataArr = model.moduleContentList?.products
            cell.selectionStyle = .None
            
            return cell
            
        }else if model.moduleType == 101{
            let cell                = tableView.dequeueReusableCellWithIdentifier("HomeBrannerCell", forIndexPath: indexPath) as! HomeBrannerCell
            
            cell.reloadBanner((model.moduleContent?.banners)!)
            cell.selectionStyle = .None
            
            return cell

            
        }else{
            return UITableViewCell()
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        //        return 15.h
        return CGFloat.min
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == dataArr.count {
            return 70.h
        }else{
            return CGFloat.min
        }
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == dataArr.count {
            
            return hearderView()

        }else{
            return nil
        }
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        //        let model = dataArr[indexPath.section]
        //        goController(model)
    }
    func hearderView() -> UIView {
        let view = UIView()
        view.frame = CGRectMake(0, 0, MGScreenWidth, 70.h)
        view.backgroundColor = UIColor.whiteColor()
        
        let lb = UILabel.initLable("一  为 你 推 荐  一", titleColor: UIColor.blackColor(), textAlignment: .Center, font: 20)
        
        let lb1 = UILabel.initLable("F    O    R    Y    O    U", titleColor: UIColor.blackColor(), textAlignment: .Center, font: 11)
        let lbBottom = UILabel.initLable(" ", titleColor: UIColor.blackColor(), textAlignment: .Center, font: 10)
        lbBottom.backgroundColor = UIColor.init(hexString: "eaeaea")
        
        view.addSubview(lb)
        
        view.addSubview(lb1)
        view.addSubview(lbBottom)
        lb.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.top.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-35)
        }
        lb1.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.top.equalTo(lb).offset(10)
            make.bottom.equalTo(view).offset(10)
        }
        lbBottom.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(0.5)
            make.left.equalTo(view)
            make.bottom.equalTo(view).offset(0)
        }
        return view

    }
}
extension WOWController:WOWHomeFormDelegate{
    func goToVC(){
//        print("跳转到专题列表")
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        self.navigationController?.pushViewController(vc, animated: true)

    }

}


extension WOWController:SenceCellDelegate{
    func senceProductClick(produtID: Int) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = produtID
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWController: CyclePictureViewDelegate {
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = bannerArray[indexPath.row]
        
        goController(model)
    }
}

//extension WOWController:HidingNavigationBarManagerDelegate{
//    func hidingNavigationBarManagerDidChangeState(manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
//        if state == .Closed {
//            DLog("dismiss")
//        }
//    }
//    
//    func hidingNavigationBarManagerDidUpdateScrollViewInsets(manager: HidingNavigationBarManager) {
//        
//    }
//}
