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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
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
//        configureSearchController()
        tableView.register(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
        configBuyBarItem()
        addObserver()

        
        tableView.mj_header = self.mj_header
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }

    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }
  

    fileprivate func configureSearchController() {
        let resultVC = WOWSearchResultController()
        resultVC.delegate = self
//        let nav = UINavigationController(rootViewController:resultVC)
        searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchResultsUpdater = self
        //输入搜索关键字的时候，整个view背景变暗淡
//        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar"), for:UIControlState())
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
        searchController.view.backgroundColor = UIColor.white
        searchController.searchBar.placeholder = "请输入搜索关键字"
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.setValue("取消", forKey:"_cancelButtonText")
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:Fontlevel002], forState: .Normal)
        } else {
            
        }
        //讓搜尋列(search bar)的尺寸跟tableview所顯示的尺寸一致
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func isStringContainsNumber( _ _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_BrandList, successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.endRefresh()

                
                strongSelf.dataArray.removeAll()
                strongSelf.originalArray.removeAll()
                
                let arr        = JSON(result)["brandVoList"].arrayObject
     
                if let dataArr = arr{
                    
                    let brands  = Mapper<WOWBrandV1Model>().mapArray(dataArr)
                    
                    //循环所有的然后给分组
                    for letter in strongSelf.headerIndexs{
                        let group_row    = brands!.filter{ (brand) in brand.letter == letter }
                            strongSelf.dataArray.append(group_row)
                            strongSelf.originalArray.appendContentsOf(group_row)
                        
                    }
                    //for #
                    let group_row    = brands!.filter{ (brand) in self!.isStringContainsNumber(brand.letter ?? "") == true }
                    
                    strongSelf.dataArray.removeLast()
                    strongSelf.originalArray.removeLast()

                    strongSelf.dataArray.append(group_row)
                    strongSelf.originalArray.appendContentsOf(group_row)

                    strongSelf.endRefresh()

                }
                strongSelf.tableView.reloadData()

            }
        }) {(errorMsg) in
            self.endRefresh()
        }
    }
}

extension WOWBrandListController:UITableViewDelegate,UITableViewDataSource{
    //实现索引数据源代理方法
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return headerIndexs
    }
    
    //点击索引，移动TableView的组位置
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        //遍历索引值
        for (index,character) in headerIndexs.enumerated(){
            //判断索引值和组名称相等，返回组坐标
            if character == title{
                return index
            }
        }
        return 0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWBaseStyleCell", for: indexPath) as! WOWBaseStyleCell
        let model = dataArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
//        cell.leftImageView.set_webimage_url(model.image)
//         修改来回上下加载 内存不减的问题
        cell.leftImageView.set_webimage_url_base(model.image, place_holder_name: "placeholder_product")
        cell.centerTitleLabel!.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerIndexs[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = model.id
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWBrandListController:SearchResultDelegate{
    func searchResultSelect(_ model: WOWBrandV1Model) {
//        searchController.searchResultsController?.dismissViewControllerAnimated(false, completion: nil)
        searchController.isActive = false
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = model.id
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWBrandListController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        //根据searchString进行过滤
        let arr = originalArray.filter { (model) -> Bool in
            if model.brandEname?.range(of: text) != nil{
                return true
            }else if model.name?.range(of: text) != nil{
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
