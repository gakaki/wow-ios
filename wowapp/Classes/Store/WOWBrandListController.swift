//
//  WOWBrandListController.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBrandListController: WOWBaseViewController {
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    //数据集合
    var originalArray   = [WOWBrandV1Model]()
    //数据源
    var dataArray       = [[WOWBrandV1Model]]()
    //有使用Search Controller时，显示的数据源
    var filteredArray = [WOWBrandModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK:Lazy
    var headerIndexs = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionIndexColor = GrayColorlevel1
        tableView.clearRestCell()
        navigationItem.title = "品牌"
        configureSearchController()
        tableView.registerNib(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
    }

    private func configureSearchController() {
        let resultVC = WOWSearchResultController()
        resultVC.delegate = self
//        let nav = UINavigationController(rootViewController:resultVC)
        searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchResultsUpdater = self
        //输入搜索关键字的时候，整个view背景变暗淡
//        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar"), forState:.Normal)
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.view.backgroundColor = UIColor.whiteColor()
        searchController.searchBar.placeholder = "请输入搜索关键字"
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        searchController.searchBar.setValue("取消", forKey:"_cancelButtonText")
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:Fontlevel002], forState: .Normal)
        } else {
            
        }
        //讓搜尋列(search bar)的尺寸跟tableview所顯示的尺寸一致
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_BrandList, successClosure: { [weak self](result) in
            if let strongSelf = self{
                
                let arr        = JSON(result)["brandVoList"].arrayObject
     
                if let dataArr = arr{
                    
                    let brands  = Mapper<WOWBrandV1Model>().mapArray(dataArr)
                    
                    //循环所有的然后给分组
                      for letter in strongSelf.headerIndexs{
                        let group_row    = brands!.filter{ (brand) in brand.letter == letter }
                        strongSelf.dataArray.append(group_row)
                        strongSelf.originalArray.appendContentsOf(group_row)
                    }

                    
                    strongSelf.tableView.reloadData()
                }
            }
        }) {(errorMsg) in
                
        }
    }
}

extension WOWBrandListController:UITableViewDelegate,UITableViewDataSource{
    //实现索引数据源代理方法
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return headerIndexs
    }
    
    //点击索引，移动TableView的组位置
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        //遍历索引值
        for (index,character) in headerIndexs.enumerate(){
            //判断索引值和组名称相等，返回组坐标
            if character == title{
                return index
            }
        }
        return 0
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWBaseStyleCell", forIndexPath: indexPath) as! WOWBaseStyleCell
        let model = dataArray[indexPath.section][indexPath.row]
        cell.leftImageView.set_webimage_url(model.image)
        cell.centerTitleLabel!.text = model.name
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerIndexs[section]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.section][indexPath.row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = model.id?.toInt()
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWBrandListController:SearchResultDelegate{
    func searchResultSelect(model: WOWBrandV1Model) {
//        searchController.searchResultsController?.dismissViewControllerAnimated(false, completion: nil)
        searchController.active = false
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = model.id?.toInt()
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWBrandListController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        //根据searchString进行过滤
        let arr = originalArray.filter { (model) -> Bool in
            if model.brandEname?.rangeOfString(text) != nil{
                return true
            }else if model.name?.rangeOfString(text) != nil{
                return true
            }else{
                return false
            }
        }
        
        let resultVC = searchController.searchResultsController as! WOWSearchResultController
//        let  resultVC = nav.topViewController as! WOWSearchResultController
        resultVC.resultArr = arr
        resultVC.tableView.reloadData()
    }
}
