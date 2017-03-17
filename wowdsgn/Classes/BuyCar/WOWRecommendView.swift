//
//  WOWRecommendView.swift
//  WOWTimerView
//
//  Created by 陈旭 on 2016/12/9.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit

class WOWRecommendView: UIView,UITableViewDelegate,UITableViewDataSource,HomeBottomDelegate {
    open var bottomListArray    = [WOWProductModel](){//底部列表数组 ,如果有底部瀑布流的话
        didSet{
            
            bottomListCount = bottomListArray.count
            bottomCellLine  = bottomListCount.getParityCellNumber()
        }
    }
    var isRreshing : Bool = false
    var pageIndex = 1 //翻页
    open var bottomListCount    = 0 // 底部数组个数
    open var bottomCellLine     = 0 // 底部cell number
    @IBOutlet weak var tableView: UITableView!
    
    lazy var mj_header:WOWRefreshHeader = {
        
        let h = WOWRefreshHeader(refreshingTarget:self, refreshingAction:#selector(pullToRefresh))!
        h.isAutomaticallyChangeAlpha = true
        return h
    }()
    
    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))!
        f.setTitle("- WOWDSGN -",  for: .noMoreData)
        f.stateLabel.textColor = UIColor(hexString: "CCCCCC")
        f.stateLabel.font = UIFont.systemFont(ofSize: 14)
        f.isAutomaticallyHidden = true
        return f
    }()

    func pullToRefresh(){
        print("下来刷新")
        if isRreshing {
            return
        }else{
            pageIndex = 1
            isRreshing = true
        }
        LoadView.dissMissView()
        requestBottom()

    }
    func loadMore(){
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        requestBottom()

        print("上拉加载")
    }
    func endRefresh() {
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
        self.isRreshing = false
    }
    
    
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        
        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            bottomListArray.ergodicArrayWithProductModel(dic: send_obj)
            
            self.tableView.reloadData()
            
        }
        
    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    deinit {
           NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
    }
    override func awakeFromNib() {
        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 410
        self.tableView.mj_header = mj_header
        self.tableView.mj_footer = mj_footer
        self.backgroundColor = DefaultBackColor
        self.tableView.backgroundColor = DefaultBackColor
        self.tableView.register(UINib.nibName("HomeBottomCell"), forCellReuseIdentifier: "HomeBottomCell")
        addObserver()
        requestBottom()

    }
    func requestBottom()  {
        
  
        
        WOWNetManager.sharedManager.requestWithTarget(.api_CartBottomList(pageSize: currentPageSize, currentPage: pageIndex), successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.bottomListArray = []

                        
                    }
                    if bannerList.count < currentPageSize {// 如果拿到的数据，小于分页，则说明，无下一页
                        
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                        
                    }
                    
                    strongSelf.bottomListArray.append(contentsOf: bannerList)
                    
                }else {
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.bottomListArray = []
                    }
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
                    strongSelf.tableView.reloadData()
                    WOWHud.dismiss()
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return bottomCellLine
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "HomeBottomCell", for: indexPath) as! HomeBottomCell
        
        cell.indexPath = indexPath
//        cell.pageTitle = vc?.title ?? ""
//        cell.moduleId = model.moduleId ?? 0
        
        let OneCellNumber = ((indexPath as NSIndexPath).section + 0) * 2
        let TwoCellNumber = (((indexPath as NSIndexPath).section + 1) * 2) - 1
        if bottomListCount.isOdd && (indexPath as NSIndexPath).section + 1 ==   bottomListCount.getParityCellNumber() {//  满足为奇数 第二个item 隐藏
            
            self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:bottomListArray)
            
        }else{
            
            self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:bottomListArray)
            
        }
        cell.delegate = self
        cell.selectionStyle   = .none

        return cell

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 325
        }else {
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView()
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func headerView() -> UIView {
        
        let view = Bundle.main.loadNibNamed("WOWBuyCarEmpty", owner: self, options: nil)?.last as! WOWBuyCarEmpty
        return view
        
    }

    // 配置cell的UI
    func cellUIConfig(one: NSInteger, two: NSInteger ,isHiddenTwoItem: Bool, cell:HomeBottomCell,dataSourceArray:[WOWProductModel])  {
        let  modelOne = dataSourceArray[one]
        if isHiddenTwoItem == false {
            
            cell.showDataOne(modelOne)
            cell.twoLb.isHidden = false
            
        }else{
            
            let  modelTwo = dataSourceArray[two]
            cell.showDataOne(modelOne)
            cell.showDataTwo(modelTwo)
            cell.twoLb.isHidden = true
        }
        
        cell.oneBtn.tag = one
        cell.twoBtn.tag = two
        
    }
    // 跳转产品详情代理
    func goToProductDetailVC(_ productId: Int?, selectedImage: UIImageView!){
        VCRedirect.toVCProduct(productId)
        
    }

}
