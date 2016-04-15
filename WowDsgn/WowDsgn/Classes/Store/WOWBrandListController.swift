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
    var dataArray = [[WOWBrandListModel]]()
    //有使用Search Controller时，显示的数据源
    var filteredArray = [String]()
    var showHeaderIndexs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        initData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK:Lazy
    var headerIndexs = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
//MARK:Private Method
    private func initData(){
        //FIXME:要搞定的
        /*
            小Bug
         */
        
        //FIXME:测试数据
        let names = ["Alibaba","jianjiao","阿玛尼","蒂芙尼","正式","阿玛尼","阿玛尼","阿玛尼","阿玛尼","正式","正式","正式","正式","正式","正式","阿玛尼","阿玛尼","阿玛尼","阿玛尼","阿玛尼","阿玛尼"]
        var brands = [WOWBrandListModel]()
        for i in names {
            let model = WOWBrandListModel()
            model.brandCountry = "意大利"
            model.brandName = i
            model.imageUrl = nil
            brands.append(model)
        }
        
        let pinyinBrands = brands.map { (model) -> String in
            let name = model.brandName ?? ""
            return name.toPinYin().uppercaseString
        }
        
        for item in pinyinBrands {
            let c = String(item.characters.first!)
            if !(c >= "A" && c <= "Z") {
                break
            }
            if !showHeaderIndexs.contains(c) {
                showHeaderIndexs.append(c)
            }
        }
        showHeaderIndexs.sortInPlace { (str1, str2) -> Bool in
            return str1 < str2
        }
        showHeaderIndexs.append("#")
       
        for item in headerIndexs {
            let models = brands.filter({ (model) -> Bool in
                let name = model.brandName ?? ""
                return name.toPinYin().uppercaseString.hasPrefix(item)
            })
            if !models.isEmpty {
                dataArray.append(models)
            }
        }
        let otherBrand = brands.filter { (model) -> Bool in
            let name = model.brandName ?? ""
            let c =  name.toPinYin().uppercaseString.characters.first!
            return !(c >= "A" && c <= "Z")
        }
        if !otherBrand.isEmpty {
            dataArray.append(otherBrand)
        }
        tableView.reloadData()
    }
    
    
    override func setUI() {
        super.setUI()
        tableView.sectionIndexColor = GrayColorlevel1
        self.edgesForExtendedLayout = .None
        navigationItem.title = "品牌"
        configureSearchController()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //輸入搜尋關鍵字的時候，讓整個view背景變得黯淡
//        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "search"
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar"), forState:.Normal)
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
        searchController.view.backgroundColor = UIColor.whiteColor()
//        searchController.searchBar.delegate = self
        //讓搜尋列(search bar)的尺寸跟tableview所顯示的尺寸一致
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
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
        cell.textLabel?.text = "\(model.brandName!)"
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showHeaderIndexs[section]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}

extension WOWBrandListController:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let _ = searchController.searchBar.text else {
            return
        }
        
        //根据searchString进行过滤
    }

}
