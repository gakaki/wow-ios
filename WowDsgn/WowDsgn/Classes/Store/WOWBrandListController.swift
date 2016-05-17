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
    
    //原始数据源
    var dataArray = [[WOWBrandModel]]()
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
    private func initData(){
        
    }
    
    override func setUI() {
        super.setUI()
        tableView.sectionIndexColor = GrayColorlevel1
        tableView.clearRestCell()
        navigationItem.title = "品牌"
        configureSearchController()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
//        tableView.registerNib(UINib.nibName(String(WOWGoodsParamCell)), forCellReuseIdentifier:String(WOWGoodsParamCell))
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //输入搜索关键字的时候，整个view背景变暗淡
//        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar"), forState:.Normal)
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
                let dict = JSON(result).dictionary
                if let dataDcit = dict{
                    for letter in strongSelf.headerIndexs{
                        let arrary = dataDcit[letter]?.arrayObject
                        let letterArr = Mapper<WOWBrandModel>().mapArray(arrary)
                        if let retArr = letterArr{
                            strongSelf.dataArray.append(retArr)
                        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let model = dataArray[indexPath.section][indexPath.row]
        cell.imageView!.kf_setImageWithURL(NSURL(string:model.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.textLabel!.text = model.name
        cell.selectionStyle = .None
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
        vc.brandID = model.id
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WOWBrandListController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let _ = searchController.searchBar.text else {
            return
        }
        //根据searchString进行过滤
    }
}
