//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import VTMagic
import RxSwift

class WOWSearchController: WOWBaseViewController {
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isLoadPrice: Bool = false
    var dataArr = [WOWProductModel]()
    var ob_cid                                  = Variable(10)
    var ob_tab_index                            = Variable(UInt(0))
    
    fileprivate var keyWords = [AnyObject](){
        didSet{
            /**
             *  如果热门搜索没有view就隐藏
             */
            if keyWords.isEmpty {
//                searchTagView.hotSearchView.hidden = true
            }else{
//                searchTagView.hotSearchView.hidden = false
            }
        }
    }
    
    fileprivate var searchArray = [String](){
        didSet{
            /**
             *  如果搜索历史没有view就隐藏
             */
            if searchArray.isEmpty {
//                searchTagView.hisSearchView.hidden = true
            }else{
//                searchTagView.hisSearchView.hidden = false
            }
        }
    }
    
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
        
       requestHotKey()
        _ = Observable.combineLatest( ob_cid.asObservable() , ob_tab_index.asObservable() ) {
            ($0,$1)
            }.throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { cid,tab_index in
                
                self.refreshSubView(tab_index)
            })

       
    }
    
  
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItems = nil
        makeCustomerNavigationItem("", left: true, handler:nil)
        navigationItem.rightBarButtonItem = nil
        makeCustomerNavigationItem("", left: false, handler: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
        searchView.removeFromSuperview()
        self.v_bottom.magicView.removeFromSuperview()
    }

    
//MARK:Lazy
    lazy var searchView:WOWSearchBarView = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWSearchBarView), owner: self, options: nil)?.last as! WOWSearchBarView
        view.frame = CGRect(x: 9, y: 6, width: MGScreenWidth - 18,height: 30)
        view.searchTextField.delegate = self
        view.searchTextField.becomeFirstResponder()
        view.cancelButton.addTarget(self, action:#selector(cancel), for:.touchUpInside)
        return view
    }()
    
    
    lazy var v_bottom: VCVTMagic = {
        let v = VCVTMagic()
        v.magicView.dataSource = self
        v.magicView.delegate = self
        v.magicView.isMenuScrollEnabled    = true
        v.magicView.isSwitchAnimated       = true
        v.magicView.isScrollEnabled        = true
        
        v.magicView.backgroundColor = UIColor.white
        self.addChildViewController(v)
        v.magicView.frame = CGRect(x: 0, y: 0,width: MGScreenWidth,height: MGScreenHeight - 64)
        v.magicView.isHidden = true
        return v
    }()
   
    lazy var emptyView: UIView = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWEmptySearchView), owner: self, options: nil)?.last as! WOWEmptySearchView
        view.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight)
        view.isHidden = true
        return view

    }()


//MARK:Private Method
    override func setUI() {
        navigationController?.navigationBar.addSubview(searchView)

        defaultSetup()
        defaultData()

        self.view.addSubview(emptyView)
    }
    
    func defaultSetup() {
        
        
        //设置布局
        collectionView.setCollectionViewLayout(WOWSearchLayout(), animated: true)
        
        collectionView.register(UINib.nibName(String(WOWSearchCell)), forCellWithReuseIdentifier: "WOWSearchCell")
        
        collectionView.register(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWReuseSectionView")
        //加载cell
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        //加载cell的头部
  

       
    }
 
    func defaultData() {
        let sql = "SELECT * FROM t_searchModel order by id desc;"
                let resultSet = WOWSearchManager.shareInstance.db.executeQuery(sql, withArgumentsInArray: nil)
                searchArray = [String]()
                while resultSet.next() {
                    
                    let searchStr = resultSet.stringForColumn("searchStr")
                    
                    searchArray.append(searchStr)
                }
            collectionView.reloadData()
    
    }
    
    
    /**
     添加搜索历史，筛选出重复的字段
     
     - parameter searchStr: 
     */
    func searchHistory(_ searchStr: String) {
        if searchArray .contains(searchStr) {
            searchArray.removeObject(searchStr)
        }
        searchArray.insertAsFirst(searchStr)
        collectionView.reloadData()
        WOWSearchManager.shareInstance.insert(searchStr)

    }
    
    
//MARK:Actions
    
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    func deleteClick() {
        DLog("清除历史搜索")
        WOWSearchManager.shareInstance.delectAll("1")
        searchArray.removeAll()
        collectionView.reloadData()
//        searchTagView.historyTagListView.removeAllTags()

    }
}

// MARK: - NET
extension WOWSearchController {
    func requestHotKey() {
        WOWNetManager.sharedManager.requestWithTarget(.api_SearchHot, successClosure: {[weak self] (result) in
            if let strongSelf = self {
                let json = JSON(result)
                let array = json["keywords"].arrayObject
                if let keyWords = array {
                    strongSelf.keyWords = keyWords
                    strongSelf.collectionView.reloadData()
                }
                
            }
            }) { (errorMsg) in
                
        }
    }
    
    func requestResult()  {
        WOWNetManager.sharedManager.requestWithTarget(.api_SearchResult(pageSize: 10, currentPage: pageIndex, sortBy: 1, asc: 1, seoKey: searchView.searchTextField.text ?? ""), successClosure: { [weak self](result) in
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self {
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                if let array = arr{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = array
                    strongSelf.showResult()
                }else {
                    strongSelf.emptyView.isHidden = false
                }
            }
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
//                strongSelf.emptyView.hidden = false
            }
            
        }

    }
}
//MARK:Delegate

extension WOWSearchController: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    //MARK - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    //MARK - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section  {
        case 0:
            return keyWords.count
        case 1:
            return searchArray.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWSearchCell", for: indexPath) as! WOWSearchCell
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            cell.titleLabel.text = keyWords[(indexPath as NSIndexPath).row] as? String
        case 1:
            cell.titleLabel.text = searchArray[(indexPath as NSIndexPath).row]
        default:
            cell.titleLabel.text = ""
        }
        //每组的数据
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            let title = keyWords[(indexPath as NSIndexPath).row] as! String
            searchView.searchTextField.text = title
            searchView.searchTextField.resignFirstResponder()
            requestResult()
            searchHistory(title)

        }else {
            let title = searchArray[(indexPath as NSIndexPath).row]
            searchView.searchTextField.text = title
            searchView.searchTextField.resignFirstResponder()
            requestResult()
            searchHistory(title)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView:UICollectionReusableView?
        //是每组的头
        if (kind == UICollectionElementKindSectionHeader){
            
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWReuseSectionView", for: indexPath) as? WOWReuseSectionView
            switch (indexPath as NSIndexPath).section {
            case 0:
                searchReusable?.titleLabel.text = "热门搜索"
                searchReusable?.clearButton.isHidden = true
            case 1:
                searchReusable?.titleLabel.text = "历史搜索"
                searchReusable?.clearButton.isHidden = false
                searchReusable?.clearButton.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
            default:
                searchReusable?.titleLabel.text = ""
                searchReusable?.clearButton.isHidden = true
            }

            reusableView = searchReusable!
        }
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            view.backgroundColor = UIColor.clear
            reusableView = view
        }
        return reusableView!
    }
    
    
    //MARK - UICollectionViewDelegateFlowLayout  itme的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch (indexPath as NSIndexPath).section {
        case 0:
            if keyWords.count > 0 {
                let text = keyWords[(indexPath as NSIndexPath).row] as? String
                let size = text!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil).size
                return CGSize(width: size.width+30, height: 35)
            }
        case 1:
            if searchArray.count > 0 {
                let text = searchArray[(indexPath as NSIndexPath).row]
                let size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil).size
                return CGSize(width: size.width+30, height: 35)
            }
        default:
            return CGSize(width: 80, height: 35)
        }
        

        return CGSize(width: 80, height: 35)
        
    }
    
    //MARK - 滚动就取消响应 只有scrollView的实际内容大于scrollView的尺寸时才会有滚动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchView.searchTextField.resignFirstResponder()
        
    }
    
}



extension WOWSearchController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            WOWHud.showMsg("请输入搜索关键字")
            return false
        }
        textField.resignFirstResponder()
        requestResult()

        searchHistory(textField.text!)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideResult()
        
        return true
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideResult()
        return true
    }
    func showResult() {
        
        self.view.addSubview(v_bottom.magicView)
        self.navigationShadowImageView?.isHidden = true
        v_bottom.magicView.isHidden = false
        v_bottom.magicView.reloadData(toPage: 0)
    }
    
    func hideResult()  {
        emptyView.isHidden = true
        self.navigationShadowImageView?.isHidden = false
        v_bottom.magicView.isHidden = true
        v_bottom.magicView.clearMemoryCache()
        self.v_bottom.magicView.removeFromSuperview()

    }
}



/**********************搜索结果的searchView********************************/


extension WOWSearchController:VTMagicViewDataSource{
    
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    override func vtm_prepareForReuse() {
        
    }
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["上新","销量","价格"]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        
//        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
        
////        if ( button == nil) {
//        
            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: 50)) { (asc) in
                print("you clicket status is "  , asc)
            }
            b.btnIndex = itemIndex
            if ( itemIndex <= 1) {
                b.image_is_show = false
            }else{
                b.image_is_show = true
            }
            return b
//
////        }
//        
////        return button!
//        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
//        
//        if ( button == nil) {
//            
//            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRectMake(0, 0, self.view.frame.width / 3, 50)) { (asc) in
//                
//            }
//            b.btnIndex = itemIndex
//            
//            if ( itemIndex <= 1) {
//                b.image_is_show = false
//            }else{
//                b.image_is_show = true
//            }
//            return b
//        }
//        return button!

    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
        if ((vc == nil)) {
            
            let vc_me = UIStoryboard.initialViewController("Home", identifier:String(WOWSearchChildController)) as! WOWSearchChildController
            addChildViewController(vc_me)
            return vc_me
        }
        
        return vc!;
    }
    func touchClick(_ btn:UIButton){
        DLog(btn.state)
    }
}

extension WOWSearchController:VTMagicViewDelegate{
//    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
//        
//        if let b = magicView.menuItemAtIndex(pageIndex) as! TooglePriceBtn? {
//            print("  button asc is ", b.asc)
//            
//        }
//        if pageIndex == 0 {
//            
//                if let vc = viewController  as? WOWSearchChildController {
//                    vc.dataArr = dataArr
//                    vc.asc = 1
//                    vc.pageVc = pageIndex.toInt + 1
//                    vc.seoKey = searchView.searchTextField.text
//                    vc.collectionView.reloadData()
//                }
//        }
//        
//        if pageIndex == 2{
//            guard isLoadPrice else {
//                if let vc = viewController  as? WOWSearchChildController {
//                    vc.asc = 1
//                    vc.pageVc = pageIndex.toInt + 1
//                    vc.seoKey = searchView.searchTextField.text
//                    vc.dataArr = [WOWProductModel]()
//                    vc.request()
//                }
//                return
//            }
//            
//        }
//        
//    }
//    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
//        if let b = magicView.menuItemAtIndex(itemIndex) as! TooglePriceBtn? ,
//            vc = magicView.viewControllerAtPage(itemIndex) as? WOWSearchChildController{
//            print("  button asc is ", b.asc)
//                if itemIndex == 2 {
//                    vc.asc = b.asc
//                    //价格第一次点击不知道为什么不会进这里
//                    isLoadPrice = true
//                }else {
//                    vc.asc = 1
//                }
//                vc.pageIndex = 1
//                vc.pageVc = itemIndex.toInt + 1
//                vc.seoKey = searchView.searchTextField.text
//                vc.dataArr = [WOWProductModel]()
//                vc.request()
//
//        }        
//        
//        
//    }
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid.value) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItem(at: tab_index) as! TooglePriceBtn? ,
            let vc  = self.v_bottom.magicView.viewController(atPage: tab_index) as? WOWSearchChildController
        {
            let query_sortBy       = Int(tab_index) + 1 //从0开始呀这个 viewmagic的 tab_index
//            let query_cid          = ob_cid.value
            var query_asc          = 1
            if ( tab_index == 2){ //价格的话用他的排序 其他 正常升序
                query_asc          = b.asc
            }else{
                query_asc          = 1
            }
            
            vc.pageVc        = query_sortBy
            vc.asc           = query_asc
            vc.seoKey       = searchView.searchTextField.text
            vc.pageIndex           = 1 //每次点击都初始化咯
            vc.request()
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index.value = pageIndex
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        self.ob_tab_index.value = itemIndex
    }
}








