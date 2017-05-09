//
//  WOWMasterpieceController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellID = String(describing: WOWMasterpieceCell.self)
    let bannerID = String(describing: HomeBrannerCell.self)
    var categoryId = 0
    var fineWroksArr = [WOWFineWroksModel]()
    var bannerArr = [WOWHomeModle]()
    var lastContentOffset :CGFloat = 0.0
    var numberOfSection = 1
    let pageSize   = 10
    var cell_heights: [Int: CGFloat]   = [0:0]
    weak var delegate:WOWChideControllerDelegate?
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮

    @IBOutlet weak var publishBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.masterpiece_page_community_homepage)
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar = true
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
        if !UserDefaults.standard.bool(forKey: "FirstTime_Master") {
            UserDefaults.standard.set(true, forKey: "FirstTime_Master")
            UserDefaults.standard.synchronize()
            /**  第一次进入，此处把第一次进入时要进入的控制器作为根视图控制器  */
            let data = ["414-1", "414-2", "414-3"]
            let v = WOWGuidePageView(datas: data)
            let window = UIApplication.shared.windows.last
            
            window?.addSubview(guideView)
            window?.addSubview(v)

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    //MARK:Lazy
    lazy var topBtn:UIButton = {
        var btn     = UIButton(type: UIButtonType.custom)
        btn     = btn as UIButton
        btn.setBackgroundImage(UIImage(named: "backTop"), for: UIControlState())
        btn.addTarget(self, action:#selector(backTop), for:.touchUpInside)
        return btn
    }()
    //引导视图
    lazy var guideView:WOWMasterGuideView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWMasterGuideView.self), owner: self, options: nil)?.last as! WOWMasterGuideView
        return v
    }()
    
    
    func backTop()  {
        let index  = IndexPath.init(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.none, animated: true)
    }

    override func setUI() {
        super.setUI()
        configTable()
        self.view.addSubview(self.topBtn)
        self.topBtn.snp.makeConstraints {[unowned self] (make) in
            make.width.equalTo(98)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
        }
        self.topBtn.isHidden = true

        request()
    }
    //下拉刷新的时候更新顶部分类
    override func pullToRefresh() {
        super.pullToRefresh()
        if let del = delegate {
            
            del.updateTabsRequsetData()
            
        }
    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        params = ["categoryId": categoryId   ,"type": 0 ,"startRows":(pageIndex-1) * 10,"pageSize":pageSize]

        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWFineWroksModel>().mapArray(JSONObject:JSON(result)["list"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.fineWroksArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
                strongSelf.fineWroksArr = []
                strongSelf.tableView.mj_footer = nil
                strongSelf.tableView.reloadData()

                if strongSelf.pageIndex > 1 {
                    strongSelf.pageIndex -= 1
                }
            }
        }
        
        if pageIndex == 1 {
            requestBanner()
        }
        

    }
    
    func requestBanner() {
        WOWNetManager.sharedManager.requestWithTarget(.api_Works_Banners, successClosure: {[weak self] (result, code) in
            if let strongSelf = self {
                strongSelf.bannerArr = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["banners"].arrayObject) ?? [WOWHomeModle]()
                if strongSelf.bannerArr.count > 0 {
                    strongSelf.numberOfSection = 2
                }else{
                    strongSelf.numberOfSection = 1

                }
                strongSelf.tableView.reloadData()
            }
        }) { [weak self](errorMsg) in
            if let strongSelf = self {
                strongSelf.bannerArr = [WOWHomeModle]()
                strongSelf.numberOfSection = 1
                strongSelf.tableView.reloadData()

            }
            
        }
    }
    
    fileprivate func configTable(){
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.register(UINib.nibName(bannerID), forCellReuseIdentifier:bannerID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header          = mj_header
        tableView.mj_footer          = mj_footer
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 410
        
    }
    func getCellHeight(_ sectionIndex:Int) -> CGFloat{
        if let h = cell_heights[sectionIndex] {
            return h
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    //MARK: -- Action
    //发布
    @IBAction func publishAction(_ sender: UIButton) {
        
        guard WOWUserManager.loginStatus == true else{
            
            UIApplication.currentViewController()?.toLoginVC(true)
            
            return
        }
        MobClick.e(.upload_picture_clicks_masterpiece_page)
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWChoiceClassController.self)) as! WOWChoiceClassController
        

        self.navigationController?.pushViewController(vc, animated: true)

  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWMasterpieceController: UITableViewDataSource, UITableViewDelegate ,HomeBrannerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfSection  == 1{
            return fineWroksArr.count

        }else {
            if section == 0 {
                return 1
            }else {
                return fineWroksArr.count

            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if numberOfSection == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMasterpieceCell
            cell_heights[0] = MGScreenWidth + 10
            cell.showData(fineWroksArr[indexPath.row])
            return cell
        }else {
            if indexPath.section == 0 {
                let cell                = tableView.dequeueReusableCell(withIdentifier: bannerID, for: indexPath) as! HomeBrannerCell
                let model = bannerArr[0]
                if let banners = model.moduleContent?.banners{
                    cell.reloadBanner(banners)
                    cell.delegate = self
                    cell.moduleId = model.moduleId
                    cell.pageTitle = self.title
                }
                cell.indexPathSection = indexPath.section
                cell_heights[0]  = cell.heightAll
                return cell

            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMasterpieceCell
                cell_heights[1] = MGScreenWidth + 10
                cell.showData(fineWroksArr[indexPath.row])
                return cell
            }
        }

        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return getCellHeight(indexPath.section)
//    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if numberOfSection  == 1{
            return 0
            
        }else {
            if section == 0 {
                return 10
            }else {
                return 0
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
 
                if self.publishBtn.alpha < 1 {
                    self.changeState(alpha: 1)
                    
                }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.mj_offsetY < self.backTopBtnScrollViewOffsetY {
            self.topBtn.isHidden = true
        }else{
            self.topBtn.isHidden = false
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.5)
        let a = scrollView.contentOffset.y
  
        if a -  lastContentOffset  > 20 && a > 0{
       
            lastContentOffset = a
            if self.publishBtn.alpha  >= 0.95 {
                changeState(alpha: 0.01)

            }
            
            return
        }else if lastContentOffset - a > 20 && (a  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) {
            lastContentOffset = a
            
            if self.publishBtn.alpha < 1 {
                changeState(alpha: 1)

            }

            return
        }
        
        
    }

    func changeState(alpha:CGFloat)  {
        self.publishBtn.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.3) { [unowned self] in
            
            self.publishBtn.transform = CGAffineTransform(scaleX: alpha, y: alpha)
            self.publishBtn.alpha = alpha
        }
      
    }
    
    func gotoVCFormLinkType(model: WOWCarouselBanners) {
        VCRedirect.goToBannerTypeController(model)
    }


}
