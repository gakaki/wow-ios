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
    var dataArray = [String]()
    //有使用Search Controller时，显示的数据源
    var filteredArray = [String]()
    var shouldShowSearchResults = false

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func initData(){
        
    }
    
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "品牌"
        configureSearchController()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }

    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //輸入搜尋關鍵字的時候，讓整個view背景變得黯淡
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "search"
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar"), forState:.Normal)
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
//        searchController.searchBar.delegate = self
        //讓搜尋列(search bar)的尺寸跟tableview所顯示的尺寸一致
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension WOWBrandListController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 27
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
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
