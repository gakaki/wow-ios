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
    var isReque:Bool = false
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Apple Products"
//        tableView.style = .grouped
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        sections = [
//            Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini"]),
            Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini"]),
            Section(name: "iPad", items: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories", "Accessories"]),
            Section(name: "iPhone", items: ["iPhone 6s"]),
            Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6"]),
            Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6"]),
            Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6"]),
        ]
        self.tableView.register(UINib.nibName("Cell_105_Item"), forCellReuseIdentifier: "Cell_105_Item")
        request()
    }
    func request()  {
        
        let params = ["pageId": 5, "region": 1]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                let bannerList = Mapper<WOWHomeClassTabs>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
                
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                }
                
                strongSelf.isReque = true
                
                strongSelf.tableView.reloadData()
                
                //                }
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
//                strongSelf.endRefresh()
            }
        }

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
        if let banners = model_Class?.banners {
            
            cell.lb_BannerName.text = banners[indexPath.row].bannerTitle ?? ""
            
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
//        if isReque {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
            
//            header.titleLabel.text = sections[section].name
//            header.arrowLabel.text = ">"
//            header.setCollapsed(sections[section].collapsed)
            
            let model = dataArr[section]
            
            let model_Class = model.moduleContent
            if let imageName = model_Class?.background{
                header.imgBanner.set_webimage_url(imageName)
            }

            header.section = section
            header.delegate = self
            
            return header
//        }else {
//            return nil
//        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
}

extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let model = dataArr[section]
        
        let model_Class = model.moduleContent
        let collapsed = !(model.moduleContent?.bannerIsOut)!
//         == true
        
        
//        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        
       model.moduleContent?.bannerIsOut = collapsed
//        header.setCollapsed(collapsed)
        
//        let model = dataArr[section]
//        return (model.moduleContent?.banners?.count ?? 1)
        
        //        return sections[section].items.count
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        if let banners = model.moduleContent?.banners {
            for i in 0 ..< banners.count {
                tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
            }
            
        }
        
        tableView.endUpdates()
        let b = IndexPath.init(row: 0, section: section) // 滚动当前组 到顶部
        tableView.scrollToRow(at: b, at: .top, animated: true)
    }
    
}
