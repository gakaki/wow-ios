//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSearchController: WOWBaseViewController {
    var menuView:WOWTopMenuTitleView!
    @IBOutlet weak var containerView: UIView!
    var pageController:UIPageViewController!
    var controllers:[UIViewController] = []
    var lastPage = 0
    var currentPage:Int = 0{
        didSet{
            
        }
    }

    
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchView.hidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        searchView.removeFromSuperview()
    }

    

    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationController?.navigationBar.addSubview(searchView)
        navigationItem.leftBarButtonItems = nil
        makeCustomerNavigationItem("", left: true, handler:nil)
        configCheckView()
        configChildControllers()
    }
    
    private func configChildControllers(){
        pageController = self.childViewControllers.first as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        let vc1 = UIStoryboard.initialViewController("Home", identifier:"WOWSearchChildController")
        let vc2 = UIStoryboard.initialViewController("Home", identifier:"WOWSearchChildController")
        pageController.setViewControllers([vc1], direction:UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        controllers = [vc1,vc2]
    }
    
    private func configCheckView(){
        WOWCheckMenuSetting.defaultSetUp()
        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, MGScreenWidth, 40), titles: ["热门搜索","搜索历史"])
        menuView.delegate = self
        WOWBorderColor(menuView)
        self.view.addSubview(menuView)
    }
    
    
    
//MARK:Actions
    
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }
    
//MARK:Lazy
    lazy var searchView:WOWSearchBarView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchBarView), owner: self, options: nil).last as! WOWSearchBarView
        view.frame = CGRectMake(15, 8, MGScreenWidth - 30,30)
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
        view.searchTextField.delegate = self
        view.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        return view
    }()
    

}


//MARK:Delegate

extension WOWSearchController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vcIndex = controllers.indexOf(viewController)
        if vcIndex >= controllers.count - 1{
            return nil
        }else{
            return controllers[vcIndex! + 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vcIndex = controllers.indexOf(viewController)
        if vcIndex <= 0{
            return nil
        }else{
            return controllers[vcIndex! - 1]
        }
    }
    
    //PageViewController滚动结束
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let v = pageViewController.viewControllers?.first
        let index = Int(controllers.indexOf(v!)!)
        menuView.selectedIndex = index
    }
}

extension WOWSearchController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        DLog("选择了\(index)")
        currentPage = index
        if currentPage > lastPage {
             pageController.setViewControllers([controllers[currentPage]], direction:.Forward, animated: true, completion: nil)
        }else{
             pageController.setViewControllers([controllers[currentPage]], direction:.Reverse, animated: true, completion: nil)
        }
    }
}

extension WOWSearchController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        DLog("开始搜索吧")
        return true
    }
    
    
}