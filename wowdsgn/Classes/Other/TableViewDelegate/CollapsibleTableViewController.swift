//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

//
// MARK: - View Controller
//
class CollapsibleTableViewController: UITableViewController {
    var dataArr = [WOWHomeClassTabs]()    //顶部商品列表数组
    var sections = [Section]()
    var headerHeight = [CGFloat]()
    var isReque:Bool = false
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.white
        self.title = "Apple Products"
        self.tableView.separatorStyle = .none

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
                    strongSelf.headerHeight.removeAll()
                    for module in brandArray {
                       
                        let height = WOWArrayAddStr.get_img_sizeNew(str: module.moduleContent?.background ?? "", width: MGScreenWidth, defaule_size: .ThreeToOne)
                        strongSelf.headerHeight.append(height)
                    }
                }
                
                strongSelf.isReque = true
                
                strongSelf.tableView.reloadData()
                
                //                }
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
extension CollapsibleTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(sections[section].items.count)
        let model = dataArr[section]
        return (model.moduleContent?.banners?.count ?? 1)
//        return sections[section].items.count
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
//        if isReque {
        let model = dataArr[indexPath.section]
        
        let model_Class = model.moduleContent
        
        guard model.moduleContent?.bannerIsOut == true else {// 返回 0
            
            return 0
        }
        
        return 55

       
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
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

extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let model = dataArr[section]
        guard let model_Class = model.moduleContent else {
            return
        }
//        let model_Class = model.moduleContent
       
        if model_Class.bannerIsOut == true {
            model_Class.bannerIsOut = false
        }else {
            model_Class.bannerIsOut = true
        }
        
       let collapsed = model_Class.bannerIsOut

//        header.setCollapsed(collapsed)
        
//        let model = dataArr[section]
//        return (model.moduleContent?.banners?.count ?? 1)
        
        //        return sections[section].items.count
        // Adjust the height of the rows inside the section
        
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
