//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit
//全部分类
class WOWAllClassViewController: UITableViewController {
    var dataArr = [WOWHomeClassTabs]()    //顶部商品列表数组

    var headerHeight = [CGFloat]() // 存放header 高度信息

    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        MobClick.e(.Shopping_Page)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.tableView.mj_header = mjBanner_header
        self.tableView.register(UINib.nibName("Cell_105_Item"), forCellReuseIdentifier: "Cell_105_Item")
        
        request()
    }
    func request()  {
        
        let params = ["pageId": 5, "region": 1]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
         
            if let strongSelf = self{
                strongSelf.mjBanner_header.endRefreshing()
                let bannerList = Mapper<WOWHomeClassTabs>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
            
                if let brandArray = bannerList{
                   
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                    
                    for module in brandArray {// 移除非 105 的模块， 此页面暂时不考虑模块化
                        if module.moduleType != 105 {
                            strongSelf.dataArr.removeObject(module)
                        }
                    }
                    
                    strongSelf.headerHeight.removeAll()
                    for module in strongSelf.dataArr {
                       
                        let height = WOWArrayAddStr.get_img_sizeNew(str: module.moduleContent?.background ?? "", width: MGScreenWidth, defaule_size: .ThreeToOne)
                        strongSelf.headerHeight.append(height)
                    }
                }

                
                strongSelf.tableView.reloadData()

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                  strongSelf.mjBanner_header.endRefreshing()
            }
        }

    }
    
    lazy var mjBanner_header:WOWRefreshHeader = {
        
        let h = WOWRefreshHeader(refreshingTarget:self, refreshingAction:#selector(pullToRefresh))!
        h.isAutomaticallyChangeAlpha = true
        return h
    }()
    func pullToRefresh(){
        request()
    }
}

//
// MARK: - View Controller DataSource and Delegate
//
extension WOWAllClassViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let model = dataArr[section]
        return (model.moduleContent?.banners?.count ?? 1)

    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_105_Item", for: indexPath) as! Cell_105_Item
        let model = dataArr[(indexPath as NSIndexPath).section]
        let model_Class = model.moduleContent
        if model.moduleContent?.bannerIsOut == true {
            if let banners = model_Class?.banners {
                cell.lb_BannerName.isHidden     = false
                cell.lb_Line.isHidden           = false
                cell.img_Next.isHidden          = false
                cell.lb_BannerName.text = banners[indexPath.row].bannerTitle ?? ""
                
            }
        }else {
            cell.lb_BannerName.isHidden     = true
            cell.lb_Line.isHidden           = true
            cell.img_Next.isHidden          = true
        }
        
       
        return cell
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let model = dataArr[indexPath.section]
    
        guard model.moduleContent?.bannerIsOut == true else {// 返回 0
            
            return 0
        }
        
        return 50

       
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? WOWAllClassViewHeader ?? WOWAllClassViewHeader(reuseIdentifier: "header")
        
            let model = dataArr[section]
            
            let model_Class = model.moduleContent
            if let imageName = model_Class?.background{
                header.imgBanner.set_webimage_url(imageName)
            }

            header.section = section
            header.delegate = self
            
            return header

        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.section]
        
        guard model.moduleContent?.bannerIsOut == true else {// 如果为展开状态
            
            return
        }
        if let banners = model.moduleContent?.banners {
            let bannerModel = banners[indexPath.row]
            //Mob 分类模块 banner点击
            let optionId = String(format: "%i_全部分类_%i", model.moduleId ?? 0, bannerModel.id ?? 0)
            let optionName = String(format: "%i_全部分类_%@", model.moduleId ?? 0, bannerModel.bannerTitle ?? "")
            let bannerName = String(format: "%i_全部分类_%@", model.moduleId ?? 0, model.moduleContent?.name ?? "")
            let params = ["Module_ID_Mainpagename_OptionId": optionId, "Module_ID_Mainpagename_OptionName": optionName, "Module_ID_Mainpagename_BannerName": bannerName]
            MobClick.e2(.Category_Option , params)
            VCRedirect.goToBannerTypeController(banners[indexPath.row])

        }

    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
}

extension WOWAllClassViewController: WOWAllClassViewHeaderDelegate {
    
    func toggleSection(_ header: WOWAllClassViewHeader, section: Int) {
        let model = dataArr[section]
        guard let model_Class = model.moduleContent else {
            return
        }
        //Mob 分类模块 banner点击
        let bannerId = String(format: "%i_全部分类_%i", model.moduleId ?? 0, model_Class.id ?? 0)
        let bannerName = String(format: "%i_全部分类_%@", model.moduleId ?? 0, model_Class.name ?? "")
        let bannerPosition = String(format: "%i_全部分类_%i", model.moduleId ?? 0, section)
        let params = ["Module_ID_Mainpagename_Bannerid": bannerId, "Module_ID_Mainpagename_Bannername": bannerName, "Module_ID_Mainpagename_Bannerposition": bannerPosition]
        MobClick.e2(.Category_Banner , params)

//        let model_Class = model.moduleContent

       
        if model_Class.bannerIsOut == true {
            model_Class.bannerIsOut = false
        }else {
            model_Class.bannerIsOut = true
        }
        
       let collapsed = model_Class.bannerIsOut

        
        for module in dataArr.enumerated() {// 循环遍历 确保 只有一个展开的 banner
              let type = module.element.moduleType ?? 0
                let id   = module.element.moduleContent?.id ?? 0
                if type == 105 {
                   if id != model_Class.id { // 不是当前所点击的
                        if module.element.moduleContent?.bannerIsOut == true { //  如果其他展开 则收起
                                module.element.moduleContent?.bannerIsOut = false
                                if let banners = module.element.moduleContent?.banners {
                                    for i in 0 ..< banners.count {
                                        tableView.reloadRows(at: [IndexPath(row: i, section: module.offset)], with: .none)
                                    }
                                
                                }
//                                let indexSet = NSIndexSet.init(index: module.offset)
//
//                                self.tableView.reloadSections(indexSet as IndexSet, with: .none)

                        }
                                               
                    }
                }
        }

        
        tableView.beginUpdates()
        if let banners = model.moduleContent?.banners {
            for i in 0 ..< banners.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .none)
            }
            
        }
        tableView.endUpdates()
        if collapsed {
            let b = IndexPath.init(row: 0, section: section) // 滚动当前组 到顶部
            tableView.scrollToRow(at: b, at: .top, animated: true)
        }else {
            let b = IndexPath.init(row: 0, section: section) // 滚动当前组 到顶部
            tableView.scrollToRow(at: b, at: .none, animated: true)
        }
       
    }
    
}
extension WOWAllClassViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    @objc(titleForEmptyDataSet:) public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = WOWEmptyNoDataText
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    @objc(backgroundColorForEmptyDataSet:) public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return GrayColorLevel5
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
