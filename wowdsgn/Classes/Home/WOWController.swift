//
//  WOWController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
struct HomeCellType {
    
    static let cell_101      = "HomeBrannerCell"
    
    static let cell_201      = "WOWlListCell"
    
    static let cell_601      = "WOWHomeFormCell"
    
    static let cell_701      = "WOWHotStyleCell"
    
    static let cell_HomeList = "HomeBottomCell"// 底部列表
    
}

class WOWController: WOWBaseViewController {
    let cellID = String(describing: WOWlListCell.self)
    
    var dataArr = [WOWHomeModle]()    //顶部商品列表数组
    var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    
    var bottomListArray = [WOWFoundProductModel]() //底部列表数组
    
    var bottomListCount :Int = 0//底部列表数组的个数
    
    var offsetY :CGFloat = 0
    
    var isOverBottomData :Bool? //底部列表数据是否拿到全部
    
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮
    
    @IBOutlet var tableView: UITableView!
    //    var hidingNavBarManager: HidingNavigationBarManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
//         self.tabBarController!.title = "尖叫设计"
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        guard (sender.object != nil) else{//
                    return
        }
        for a in 0..<bottomListArray.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = bottomListArray[a]
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                }
            }
          
        }
         self.tableView.reloadData()
    }
    lazy var banner:WOWBanner = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWBanner.self), owner: self, options: nil)?.last as! WOWBanner
        view.cyclePictureView.delegate = self
        view.jsButton.addTarget(self, action: #selector(jsClick), for: .touchUpInside)
        view.dgButton.addTarget(self, action: #selector(dgClick), for: .touchUpInside)
        view.zdButton.addTarget(self, action: #selector(zdClick), for: .touchUpInside)
        view.sjButton.addTarget(self, action: #selector(sjClick), for: .touchUpInside)
        return view
    }()
    lazy var mj_footerHome:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadBottomData))
        return f!
    }()
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        
        tableView.register(UINib.nibName(HomeCellType.cell_201), forCellReuseIdentifier:HomeCellType.cell_201)
        
        tableView.register(UINib.nibName(HomeCellType.cell_601), forCellReuseIdentifier: HomeCellType.cell_601)
        
        tableView.register(UINib.nibName(HomeCellType.cell_101), forCellReuseIdentifier: HomeCellType.cell_101)
        
        tableView.register(UINib.nibName(HomeCellType.cell_HomeList), forCellReuseIdentifier: HomeCellType.cell_HomeList)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
        
        //        configBarItem()
        tableView.mj_header = mj_header
        tableView.mj_footer = mj_footerHome
        
        self.tableView.backgroundColor = GrayColorLevel5
        
        configBarItem()
        addObserver()
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
    //MARK:Private Networkr
    override func request() {
        
        super.request()
        self.requestTop()
        self.requestBottom()
            
    }
    
    func requestTop() {
        let params = ["pageId": 1, "region": 1]
       
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params as [String : AnyObject]?), successClosure: {[weak self] (result) in
            if let strongSelf = self{
               
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
                
                if let brandArray = bannerList{
                    
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                    
                }
                if strongSelf.bottomListArray.count > 0 {// 确保reloadData 数据都存在
                     strongSelf.tableView.reloadData()
                     WOWHud.dismiss()
                }
               
                //                dispatch_group_leave(strongSelf.group);// 减少计数，证明此网络请求结束
                
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
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_BottomList(params : params), successClosure: {[weak self] (result) in
            if let strongSelf = self{
               
                strongSelf.endRefresh()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.mj_footerHome.endRefreshing()
                
                let bannerList = Mapper<WOWFoundProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.bottomListArray = []
                        strongSelf.isOverBottomData = false
                    }
                    if bannerList.count < totalPage {// 如果拿到的数据，小于分页，则说明，无下一页
                        strongSelf.tableView.mj_footer = nil
                        strongSelf.isOverBottomData = true
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footerHome
                    }
                    
                    strongSelf.bottomListArray.append(contentsOf: bannerList)
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
    //点击跳转
    func goController(_ model: WOWCarouselBanners) {
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                let vc = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWWebViewController.self)) as! WOWWebViewController
//                vc.brandID = model.bannerLinkTargetId
//                vc.entrance = .brandEntrance
//                vc.hideNavigationBar = true
                vc.bannerUrl = model.bannerLinkUrl
                navigationController?.pushViewController(vc, animated: true)
                print("web后台填连接")
            case 2:
                print("专题详情页（商品列表）")
            case 3:
                print("专题详情页（图文混排）")
            case 4:
                print("品牌详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.brandID = model.bannerLinkTargetId
                vc.entrance = .brandEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 5:
                print("设计师详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.designerId = model.bannerLinkTargetId
                vc.entrance = .designerEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                print("商品详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
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
extension WOWController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return (dataArr.count ) + bottomListCount.getParityCellNumber()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard (indexPath as NSIndexPath).section < dataArr.count  else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: "HomeBottomCell", for: indexPath) as! HomeBottomCell
            
            cell.indexPath = indexPath
          
            let OneCellNumber = ((indexPath as NSIndexPath).section  - dataArr.count + 0) * 2
            let TwoCellNumber = (((indexPath as NSIndexPath).section  - dataArr.count + 1) * 2) - 1
            if bottomListCount.isOdd {
                if (indexPath as NSIndexPath).section + 1 == (dataArr.count) + bottomListCount.getParityCellNumber() { // 如果奇数 满足则 第二个Item 不出现
                    let  modelOne = bottomListArray[OneCellNumber]

                    cell.showDataOne(modelOne)

             
                    cell.twoLb.isHidden = false
                    
                }else{
                    let  modelOne = bottomListArray[OneCellNumber]
                    let  modelTwo = bottomListArray[TwoCellNumber]
                    cell.showDataOne(modelOne)
                    cell.showDataTwo(modelTwo)
                    cell.twoLb.isHidden = true
                }
            }else{

               let  modelOne = bottomListArray[OneCellNumber]
               let  modelTwo = bottomListArray[TwoCellNumber]
                cell.showDataOne(modelOne)
                cell.showDataTwo(modelTwo)
                cell.twoLb.isHidden = true
            }
            // 排序 0，1，2，3，4...
         
            
//            let modelOne = bottomListArray[OneCellNumber]
            
//            let modelTwo = bottomListArray[TwoCellNumber]
            
            
            cell.oneBtn.tag = OneCellNumber
            cell.twoBtn.tag = TwoCellNumber
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        }
        let model = dataArr[(indexPath as NSIndexPath).section]
        
        switch model.moduleType ?? 0 {
        case 201:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_201, for: indexPath) as! WOWlListCell
            
            cell.delegate       = self
            
            cell.showData(model.moduleContent!)
            
            cell.selectionStyle = .none
            
            return cell
        case 601:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_601, for: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate         = self
            cell.modelData        = model.moduleContentList
            cell.selectionStyle   = .none
            
            return cell
        case 101:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_101, for: indexPath) as! HomeBrannerCell
            
            if let banners = model.moduleContent?.banners{
                self.bannerArray               = banners
                cell.reloadBanner(self.bannerArray)
                cell.cyclePictureView.delegate = self
            }
            
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
//        print("\(dataArr.count)--\(bottomListCount.getParityCellNumber())++\(section)")
        guard section < dataArr.count  else {
            
            if section == ((dataArr.count ) + bottomListCount.getParityCellNumber()) - 1{
                if isOverBottomData == true {
                    return 70
                }
            }
            return CGFloat.leastNormalMagnitude
        }
            return 15.h

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section < dataArr.count  else {
            
            if section == ((dataArr.count ) + bottomListCount.getParityCellNumber()) - 1{
                if isOverBottomData == true {
                    return footerView()
                }
            }
            return nil
        }
        return nil

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == dataArr.count {
            return 70
        }else{
            return CGFloat.leastNormalMagnitude
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == dataArr.count {
            
            return hearderView()
            
        }else{
            return nil
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section < dataArr.count  else {
            return
        }
        let model = dataArr[(indexPath as NSIndexPath).section]
        switch model.moduleType ?? 0{
        case 201://单个图片
            if let modelBanner = model.moduleContent {
                goController(modelBanner)
            }
        default:
            break
        }
        
    }
    func hearderView() -> UIView { // 137 37
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 70)
        view.backgroundColor = UIColor.white
        
        let img = UIImageView()
        img.image = UIImage(named: "recommend")
        view.addSubview(img)
        img.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(137)
            make.height.equalTo(37)
            make.center.equalTo(view)
        }
        let lbBottom = UILabel.initLable(" ", titleColor: UIColor.black, textAlignment: .center, font: 10)
        lbBottom.backgroundColor = UIColor.init(hexString: "eaeaea")
        view.addSubview(lbBottom)
        lbBottom.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(0.5)
            make.left.equalTo(view)
            make.bottom.equalTo(view).offset(0)
        }
        return view
        
    }
    func footerView() -> UIView {

        let view = WOWDSGNFooterView.init(frame: CGRect(x: 0, y: 0, width: MGScreenWidth,height: 70))

        return view
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.mj_offsetY < backTopBtnScrollViewOffsetY {
            self.topBtn.isHidden = true
        }else{
            self.topBtn.isHidden = false
        }
        
    }
}
extension WOWController:HomeBottomDelegate{
    
    func goToProductDetailVC(_ indexRow: Int?) {//跳转产品详情
        
        let model = bottomListArray[indexRow!]
        toVCProduct(model.productId)
        
    }

}
extension WOWController:WOWHomeFormDelegate{
    
    func goToVC(_ m:WOWModelVoTopic){//右滑更多 跳转专题详情
        if let cid = m.id{
            
            toVCTopic(cid)
            
        }
    }
    func goToProdectDetailVC(_ productId: Int?) {// 跳转产品详情页
       
        toVCProduct(productId)
        
    }
}

extension WOWController:SenceCellDelegate{
    func senceProductClick(_ produtID: Int) {//根据ID跳转产品详情页
        toVCProduct(produtID)
    }
}

extension WOWController: CyclePictureViewDelegate {
    public func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let model = bannerArray[(indexPath as NSIndexPath).row]
        
        goController(model)
    }
}