//
//  WOWBaseRouteVC.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/10.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWBaseModuleVC: WOWBaseViewController {
    

    var myQueueTimer1: DispatchQueue?
    var myTimer1: DispatchSourceTimer?
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dataDelegate: WOWTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.topBtn)
        
        self.topBtn.snp.makeConstraints {[unowned self] (make) in
            make.width.equalTo(98)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
        }
        self.topBtn.isHidden = true
    }
    //MARK:Lazy
    lazy var topBtn:UIButton = {
        var btn     = UIButton(type: UIButtonType.custom)
            btn     = btn as UIButton
            btn.setBackgroundImage(UIImage(named: "backTop"), for: UIControlState())
            btn.addTarget(self, action:#selector(backTop), for:.touchUpInside)
        return btn
    }()
    func backTop()  {
        let index  = IndexPath.init(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.none, animated: true)
    }
    
    override func setUI() {
        super.setUI()

        tableView.mj_header             = mj_header
        dataDelegate?.tableView         = tableView
        self.edgesForExtendedLayout  = UIRectEdge()
  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    // 倒计时 ，实时更新Model层数据
    func timerCount(array: Array<WOWHomeModle>){
        myQueueTimer1 = DispatchQueue(label: "myQueueTimer")
        myTimer1 = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer1!)
        myTimer1?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer1?.setEventHandler {
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
        myTimer1?.resume()
        
    }
    // 底部刷新
    lazy var mj_footerHome:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadBottomData))
        f?.stateLabel.textColor = UIColor(hexString: "CCCCCC")
        f?.stateLabel.font = UIFont.systemFont(ofSize: 14)
        return f!
    }()
    func loadBottomData()  {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        requestBottom()
        
    }
    func requestBottom()  {
        if isRreshing {
            return
        }else{
            pageIndex = 1
            isRreshing = true
        }
        
        // 关闭动画， 防止下拉刷新此界面再次出来

        LoadView.dissMissView()
        request()

    }
    // json 数据 转成model
    func dataWithHomeModel(result: AnyObject) -> Array<WOWHomeModle> {
        
        var dataArr = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
        
        if let brandArray = dataArr{
            
            var singProductArray = [WOWHomeModle]() // 今日单品 倒计时的产品 数组

            for t in brandArray{
                switch t.moduleType ?? 0 {
                case 302:
                    if let s  = t.moduleContentTmp?["categories"] as? [AnyObject] {
                        t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                    }
                case 401:
                    if let s  = t.moduleContentTmp?["products"] as? [AnyObject] {
                        t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                        t.name = (t.moduleContentTmp?["name"] as? String) ?? "本周上新"
                        
                    }
                    
                case 201:
                    if let s  = t.moduleContentTmp  {
                         t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                    }
                case 501:
                    if let s  = t.moduleContentTmp  {
                         t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                    }
                case 301:
                    if let s  = t.moduleContentTmp?["categories"] as? [AnyObject] {
                         t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                    }
                    
                case 801:
                     singProductArray.append(t)
                case 701,601,101,102,402,901,1001,103,104:
                    print("")
                default:
                    // 移除 cell for row 里面不存在的cellType类型，防止新版本增加新类型时，出现布局错误
                    dataArr?.removeObject(t)
                }
                
            }
            // 拿到数据，倒计时刷新数据源model
            if singProductArray.count > 0 {
                
                self.timerCount(array: singProductArray)
            }
            
        }
        return dataArr ?? []
    }
    
//    //点击跳转
    func goController(_ model: WOWCarouselBanners) {
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                let vc = WOWWebViewController()
                if let url = model.bannerLinkUrl{
                    vc.url = url
                }
                
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
                
            case 8:// 专题详情
                toVCTopic(model.bannerLinkTargetId ?? 0)
                print("场景还是专题")
            case 9:// 专题详情
                
                toVCTopidDetail(model.bannerLinkTargetId ?? 0)
                
            default:
                print("其他")
            }
            
        }
        
    }

}
extension WOWBaseModuleVC:HomeBottomDelegate{
    
    func goToProductDetailVC(_ productId: Int?) {//跳转产品详情
        
        toVCProduct(productId)
        
    }
    
}
extension WOWBaseModuleVC:WOWHomeFormDelegate{
    
    func goToVC(_ m:WOWModelVoTopic){//右滑更多 跳转专题详情
        if let cid = m.id{
            
            toVCTopic(cid)
            
        }
    }
    func goToProdectDetailVC(_ productId: Int?) {// 跳转产品详情页
        
        toVCProduct(productId)
        
    }
}

extension WOWBaseModuleVC:SenceCellDelegate{
    func senceProductClick(_ produtID: Int) {//根据ID跳转产品详情页
        toVCProduct(produtID)
    }
}
extension WOWBaseModuleVC:cell_102_delegate{// 左右滑动专题跳转
    func goToProjectDetailVC(_ model: WOWCarouselBanners?){
        if let model = model {
            goController(model)
        }
        
    }
}
extension WOWBaseModuleVC:cell_801_delegate{// 今日单品跳转详情
    func goToProcutDetailVCWith_801(_ productId: Int?){
        toVCProduct(productId)
    }
}
extension WOWBaseModuleVC:WOWHotStyleCellDelegate{// 点赞刷新
    
    func reloadTableViewDataWithCell(){
        
        request()
        
    }
    
}
extension WOWBaseModuleVC:WOWHotStyleDelegate{
    
    func reloadTableViewData(){
        
        request()
        
    }
    
}
extension WOWBaseModuleVC:FoundWeeklyNewCellDelegate{// 本周上新跳转
    
    func cellFoundWeeklyNewCellTouchInside(_ m:WowModulePageItemVO){

        
        if let pid = m.productId as Int? {
            self.toVCProduct(pid)
        }
    }
    
}
extension WOWBaseModuleVC:MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate{//  一级 分类 场景跳转
    
    func MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate_CellTouchInside(_ m:WowModulePageItemVO?)
    {
        if let cid = m!.categoryId , let cname = m!.categoryName{
            toVCCategory( cid ,cname: cname)
        }
    }
    
}

extension WOWBaseModuleVC:Cell_501_Delegate{// 推荐单品跳转
    
    func toProductDetail(_ productId: Int?) {
        toVCProduct(productId)
    }
    
}
extension WOWBaseModuleVC:Cell_302_Delegate{// more 一级分类跳转
    
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(_ m:WowModulePageItemVO?)
    {
        
        if m == nil {
            toVCCategoryChoose()
        }else{
            if let cid = m!.categoryId , let cname = m!.categoryName{
                toVCCategory( cid,cname: cname)
            }
        }
        
    }

    
}
extension WOWBaseModuleVC:WOWHotColumnDelegate{//点击栏目跳转
    func goToArticleListVC(_ columntId: Int?, title: String?) {
        
        toVCArticleListVC(columntId ?? 0, title: title ?? "",isOpenTag:false,isPageView: false)
        
    }
}
extension WOWBaseModuleVC:HotPeopleTitleDelegate{// 点击标签跳转
    func tagPressedWithToVC(titleId: Int, title: String?)   {
        
        toVCArticleListVC(titleId , title: title ?? "",isOpenTag:true,isPageView: false)
        
    }
}
extension WOWBaseModuleVC:Cell_104_TwoLineDelegate{// 点击标签跳转'
    
    func goToProductGroupList(_ groupId:Int){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductListController.self)) as! WOWProductListController
        vc.groupId = groupId
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
  }

