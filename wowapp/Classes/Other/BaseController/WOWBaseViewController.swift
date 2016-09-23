//
//  WOWBaseViewController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



extension UIViewController {
    static var identifier: String {
        let mirror = Mirror(reflecting: self)
        return String(describing: mirror.subjectType)
    }
}
class WOWBaseViewController: UIViewController,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    var hideNavigationBar:Bool = false
    var pageIndex = 1 //翻页
    var isRreshing : Bool = false
    var carBadgeCount: MIBadgeButton?
    var isCurrentRequest : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "line")
       
    }
    
    
    lazy var navigationShadowImageView:UIView? = {
        return self.getNavShadow(self.navigationController?.navigationBar)
    }()
    
    fileprivate func getNavShadow(_ paramView:UIView?) -> UIView?{
        if let bar = paramView{
            
            if bar.bounds.size.height <= 1.0 {
                DLog("找到了")
                return bar
            }
        }
        for subView in paramView?.subviews ?? []{
            let image = getNavShadow(subView)
            if let i = image {
                return i
            }
        }
        return nil
    }
    

//MARK:Life
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //TalkingData统计页面
        TalkingData.trackPageEnd( self.title )

        
        MobClick.endLogPageView(self.title)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //growing io 统计页面
        
        
        //TalkingData统计页面
        TalkingData.trackPageBegin( self.title )
        
        //友盟统计页面
        MobClick.beginLogPageView(self.title)
        setCustomerBack()
        if hideNavigationBar {
            //设置导航栏透明
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }
    }
    
//    
//    func hideNavSeprator(isHiden:Bool = true) {
//        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor(), size:CGSizeMake(MGScreenWidth, 1)), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//    }
//    
    func setCustomerBack() {
        if navigationController?.viewControllers.count > 1 {
            let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.plain, target: self, action:#selector(navBack))
            navigationItem.leftBarButtonItem = item
        }
    }
    
    func navBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Lazy

    
    lazy var mj_header:WOWRefreshHeader = {
        
        let h = WOWRefreshHeader(refreshingTarget:self, refreshingAction:#selector(pullToRefresh))!
        h.isAutomaticallyChangeAlpha = true
        return h
    }()

    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))!
                f.setTitle("- WOWDSGN -",  for: .noMoreData)
        f.stateLabel.textColor = UIColor(hexString: "CCCCCC")
        f.stateLabel.font = UIFont.systemFont(ofSize: 14)
        f.isAutomaticallyHidden = true
        return f
    }()
    
   
    
//MARK:Private Method
    func setUI(){
        self.view.backgroundColor = DefaultBackColor
        
    }
    
    func request(){
        if isCurrentRequest == false{
             WOWHud.showLoading()
            isCurrentRequest = true
        }
      
        
    }
    
    func loadMore() {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        request()
    }
    
    /**
     子类必须实现父类方法先
     */
    func pullToRefresh() {
        if isRreshing {
            return
        }else{
            pageIndex = 1
           isRreshing = true
        }
        // 关闭动画， 防止下拉刷新此界面再次出来
//        LoadView.sharedInstance.dissMissView()
        LoadView.dissMissView()
        request()
    }
    
    func endRefresh() {
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
        self.isRreshing = false
    }
    

//MARK:Private Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }

}


extension WOWBaseViewController{
    @objc(titleForEmptyDataSet:) func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = WOWEmptyNoDataText
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    @objc(backgroundColorForEmptyDataSet:) func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return GrayColorLevel5
    }
}

// MARK: - 购物车显示数量
extension WOWBaseViewController {
    func configBuyBarItem(){
        
        carBadgeCount = MIBadgeButton(type: .custom)
        carBadgeCount!.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        carBadgeCount!.setImage(UIImage(named: "buy"), for: UIControlState())
        if WOWUserManager.userCarCount <= 0 {
            carBadgeCount!.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carBadgeCount!.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carBadgeCount!.badgeString = "99+"
        }

        makeBuyCarNavigationItem(carBadgeCount!){[weak self] () -> () in
            if let strongSelf = self{
                guard WOWUserManager.loginStatus else {
                    strongSelf.toLoginVC(true)
                    return
                }
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController())) as! WOWBuyCarController
                vc.hideNavigationBar = false
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        makeCustomerImageNavigationItem("search1", left:true) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWSearchController())) as! WOWSearchController
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    func updateBageCount() {
        if WOWUserManager.userCarCount <= 0 {
            carBadgeCount!.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carBadgeCount!.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carBadgeCount!.badgeString = "99+"
        }
        
    }

}

extension WOWBaseTableViewController {
    
    func configBuyBarItem(_ badgeCount: Int){
        
        carBadgeCount = MIBadgeButton(type: .custom)
        carBadgeCount!.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        carBadgeCount!.setImage(UIImage(named: "buy"), for: UIControlState())
        if WOWUserManager.userCarCount <= 0 {
            carBadgeCount!.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carBadgeCount!.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carBadgeCount!.badgeString = "99+"
        }
        makeBuyCarNavigationItem(carBadgeCount!){[weak self] () -> () in
            if let strongSelf = self{
                guard WOWUserManager.loginStatus else {
                    strongSelf.toLoginVC(true)
                    return
                }
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController())) as! WOWBuyCarController
                vc.hideNavigationBar = false
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        makeCustomerImageNavigationItem("search1", left:true) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWSearchController())) as! WOWSearchController
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    func updateBageCount() {
        if WOWUserManager.userCarCount <= 0 {
            carBadgeCount!.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carBadgeCount!.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carBadgeCount!.badgeString = "99+"
        }
        
    }

}
