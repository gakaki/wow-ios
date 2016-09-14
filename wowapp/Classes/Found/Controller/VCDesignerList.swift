
import UIKit

class VCDesignerList: WOWBaseViewController {
    
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    
    //数据集合
    var originalArray   = [WOWDesignerModel]()
    //数据源
    var dataArray       = [[WOWDesignerModel]]()
    //有使用Search Controller时，显示的数据源
    var filteredArray   = [WOWBrandModel]()
    
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
        navigationItem.title = "设计师"
        configureSearchController()
        tableView.registerNib(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
        configBuyBarItem()
       
        //这个界面不需要了
//        addObserver()
        
        
        tableView.mj_header = self.mj_header
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
    }
    
    private func addObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateBageCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
        
    }
    
    
    private func configureSearchController() {
        
        let resultVC = VCDesignerListSearchResult()
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
    
    
    func isStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluateWithObject(_string)
        
        return containsNumber
    }
    //MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_DesignerList, successClosure: { [weak self](result) in
            if let strongSelf = self{
                
                strongSelf.endRefresh()

                
                strongSelf.dataArray.removeAll()
                strongSelf.originalArray.removeAll()
                
                let arr        = JSON(result)["designerVoList"].arrayObject
                
                if let dataArr = arr , designers = Mapper<WOWDesignerModel>().mapArray(dataArr) {
                    
                    //循环所有的然后给分组
                    for letter in strongSelf.headerIndexs{
                        let group_row    = designers.filter{ (d) in d.designerNameFirstLetter == letter }
                        strongSelf.dataArray.append(group_row)
                        strongSelf.originalArray.appendContentsOf(group_row)
                    }
                    //for #
                    let group_row    = designers.filter{ (d) in strongSelf.isStringContainsNumber(d.designerNameFirstLetter ?? "") == true }
                    
                    strongSelf.dataArray.removeLast()
                    strongSelf.originalArray.removeLast()
                    
                    strongSelf.dataArray.append(group_row)
                    strongSelf.originalArray.appendContentsOf(group_row)
                    
                    
                }
                
                
                
                strongSelf.tableView.reloadData()

            }

            
        }) {(errorMsg) in
            self.endRefresh()
        }
    }
}

extension VCDesignerList:UITableViewDelegate,UITableViewDataSource{
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
        //         修改来回上下加载 内存不减的问题
//        cell.leftImageView.set_webimage_url_base(model.designerPhoto, place_holder_name: "placeholder_product")
        cell.leftImageView.set_webimage_url(model.designerPhoto)
        cell.centerTitleLabel!.text = model.designerName
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerIndexs[section]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //设计师的首页

        let model = dataArray[indexPath.section][indexPath.row]
        
        let vc                  = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.designerId           = model.designerId
        vc.entrance             = .designerEntrance
        vc.hideNavigationBar    = true
//        self.parentViewController?.navigationController!.pushViewController(vc, animated: true)
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension VCDesignerList:VCDesignerListSearchResultDelegate{
    func searchResultSelect(model:WOWDesignerModel){
        //        searchController.searchResultsController?.dismissViewControllerAnimated(false, completion: nil)
        searchController.active = false
//        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
//        vc.brandID = model.id
//        vc.hideNavigationBar = true
//        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCDesignerList:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        //根据searchString进行过滤
        let arr = originalArray.filter { (model) -> Bool in
            if model.designerName?.rangeOfString(text) != nil{
                return true
            }else if model.designerNameFirstLetter?.rangeOfString(text) != nil{
                return true
            }else{
                return false
            }
        }
        
        let resultVC = searchController.searchResultsController as! VCDesignerListSearchResult
        //        let  resultVC = nav.topViewController as! WOWSearchResultController
        resultVC.resultArr = arr
        resultVC.tableView.reloadData()
    }
}
