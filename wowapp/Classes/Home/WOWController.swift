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
    var dataArr = [WOWCarouselBanners]()    //商品列表数组
    var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    @IBOutlet var tableView: UITableView!
//    var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.hideNavigationBar = true
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //FIXME:为了让动画出现 所以多reload一次咯
//        tableView.reloadData()
//        hidingNavBarManager?.viewWillAppear(animated)
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
//        navigationItem.title = "尖叫设计"
        tableView.registerNib(UINib.nibName(String(WOWlListCell)), forCellReuseIdentifier:cellID)
        tableView.backgroundColor = DefaultBackColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
//        tableView.rowHeight = CGFloat(1242)
//        configBarItem()
        tableView.mj_header = mj_header
        tableView.tableHeaderView = banner
//        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)

    }

   
    private func configBarItem(){
        /*菜单暂时不需要
        makeCustomerImageNavigationItem("menu", left: true) {[weak self] () -> () in
            if let strongSelf = self{
                let sideVC = strongSelf.appdelegate.sideController
                if sideVC.showing{//显示中
                    sideVC.hideSide()
                }else{//隐藏中
                    sideVC.showSide()
                }
            }
        }
         */
        makeCustomerImageNavigationItem("search", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

    
//MARK:Actions
    func jsClick() -> Void {
        print("家什")
        toVCCategory("10")
    }
    func dgClick() -> Void {
        print("灯光")
        toVCCategory("15")

    }
    func zdClick() -> Void {
        print("装点")
        toVCCategory("16")

    }
    func sjClick() -> Void {
        print("厨房")
        toVCCategory("11")

    }
    
//MARK:Private Networkr
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_Banners, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.dismiss()
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWlListCell
        cell.delegate = self
        let model = dataArr[indexPath.row]
        cell.showData(model)
        
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        let model       = dataArr[indexPath.row]
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                print("专题")
            case 2:
                print("品牌详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
                vc.brandID = model.bannerLinkTargetId
                vc.entrance = .brandEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)

            case 3:
                print("设计师详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
                vc.designerId = model.bannerLinkTargetId
                vc.entrance = .designerEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
            case 4:
                print("商品详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
                vc.hideNavigationBar = true
                vc.productId = model.bannerLinkTargetId
                navigationController?.pushViewController(vc, animated: true)
            default:
                print("其他")
            }
            
        }
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        hidingNavBarManager?.shouldScrollToTop()
        return true
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
        print(model.bannerLinkType)
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
            default:
                print("其他")
            }

        }
       
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

