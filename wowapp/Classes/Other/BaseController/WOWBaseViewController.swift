//
//  WOWBaseViewController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBaseViewController: UIViewController,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    var hideNavigationBar:Bool = false
    var pageIndex = 0 //翻页
    var isRreshing : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

//MARK:Life
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setCustomerBack()
        if hideNavigationBar {
            //设置导航栏透明
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    
    func setCustomerBack() {
        if navigationController?.viewControllers.count > 1 {
            let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.Plain, target: self, action:#selector(navBack))
            navigationItem.leftBarButtonItem = item
        }
    }
    
    func navBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Lazy
    lazy var mj_header:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(pullToRefresh))
        return h
    }()
    
    lazy var mj_footer:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:#selector(loadMore))
        return f
    }()
    
//MARK:Private Method
    func setUI(){
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func request(){
        
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
            pageIndex = 0
           isRreshing = true
        }
        request()
    }
    
    func endRefresh() {
        mj_header.endRefreshing()
        mj_footer.endRefreshing()
        self.isRreshing = false
    }
    

//MARK:Private Actions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }

}


extension WOWBaseViewController{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = WOWEmptyNoDataText
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return GrayColorLevel5
    }
}
