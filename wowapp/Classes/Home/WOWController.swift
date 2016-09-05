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
    
    var dataArr = [WOWCarouselBanners]()    //商品列表数组
    var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    
    let bottomListArray : Int = 5
    
    @IBOutlet var tableView: UITableView!
    //    var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //        self.hideNavigationBar = true
        requestQueue()
        requestTest()
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
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
        
        //        configBarItem()
        tableView.mj_header = mj_header
        
        self.tableView.backgroundColor = GrayColorLevel6
        
        configBarItem()
        
    }
    
    
    private func configBarItem(){
        
        makeCustomerImageNavigationItem("search", left:true) {[weak self] () -> () in
//            if let strongSelf = self{
//                
//            if strongSelf.isOpen == true {
//                strongSelf.isOpen = false
//                  WOWHudRefresh.dismiss()
//            }else{
//               strongSelf.isOpen = true
//                WOWHudRefresh.showInView((self?.view)!)
//              
//            }
//        }
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
    func requestQueue() {
        var queue: dispatch_queue_t = dispatch_get_main_queue()// 主线程
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)// 后台执行
        // 分组执行
        
        let group = dispatch_group_create()
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)// 默认优先级执行
        
            //异步执行队列任务
            
            dispatch_group_async(group, queue, { () -> Void in

                self.request()
            })
            
            dispatch_group_async(group, queue, { () -> Void in
            
                self.requestBottomList()
            })

        
        // 分组队列执行完毕后执行
        
        dispatch_group_notify(group, queue) { () -> Void in
            
            print("dispatch_group_notify")
            
        }
    }
    
    func requestTest() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_List(region: 1), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                //                WOWHud.dismiss()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModule>().mapArray(JSON(result)["moduleDataList"].arrayObject)
                print(bannerList)
                
//                let carouselBanners = Mapper<WOWCarouselBanners>().mapArray(JSON(result)["carouselBanners"].arrayObject)
//                if let carouselBanners = carouselBanners{
//                    strongSelf.bannerArray = []
//                    strongSelf.bannerArray = carouselBanners
//                }
//                if let brandArray = bannerList{
//                    strongSelf.dataArr = []
//                    strongSelf.dataArr.appendContentsOf(brandArray)
//                }
//                strongSelf.banner.reloadBanner(strongSelf.bannerArray)
//                
//                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }

    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_Banners, successClosure: {[weak self] (result) in
            if let strongSelf = self{
//                WOWHud.dismiss()
               
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWCarouselBanners>().mapArray(JSON(result)["bannerList"].arrayObject)
                print(bannerList)
                
                let carouselBanners = Mapper<WOWCarouselBanners>().mapArray(JSON(result)["carouselBanners"].arrayObject)
                if let carouselBanners = carouselBanners{
                    strongSelf.bannerArray = []
                    strongSelf.bannerArray = carouselBanners
                }
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr.appendContentsOf(brandArray)
                }
                strongSelf.banner.reloadBanner(strongSelf.bannerArray)
                
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    func requestBottomList()  {
        print("load...")
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
        return (dataArr.count ?? 0) + bottomListArray.getParityCellNumber()
        //        return 11
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        guard indexPath.section < dataArr.count  else {
            let cell                = tableView.dequeueReusableCellWithIdentifier("HomeBottomCell", forIndexPath: indexPath) as! HomeBottomCell
            
            cell.indexPath = indexPath
            
            if bottomListArray.isOdd {
                if indexPath.section + 1 == (dataArr.count) + bottomListArray.getParityCellNumber() { // 如果奇数 满足则 第二个Item 不出现
                    
                    cell.twoLb.hidden = false
                    
                }else{
                    
                    cell.twoLb.hidden = true
                    
                }
            }else{
                cell.twoLb.hidden = true
            }
            cell.oneBtn.tag = (indexPath.section  - dataArr.count + 0) * 2
            cell.twoBtn.tag = ((indexPath.section  - dataArr.count + 1) * 2) - 1
             cell.selectionStyle = .None
            return cell
            
        }
        
        if  indexPath.section%2 == 0 {
            let cell                = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWlListCell
            
            cell.delegate       = self
            let model           = dataArr[indexPath.section]
            cell.showData(model)
             cell.selectionStyle = .None
            return cell
        }else{
            
            let cell                = tableView.dequeueReusableCellWithIdentifier("WOWHomeFormCell", forIndexPath: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate = self
            cell.selectionStyle = .None
            return cell
            
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
