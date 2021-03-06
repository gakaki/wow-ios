//
//  WOWBaseTableViewController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/19.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBaseTableViewController: UITableViewController,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
//    var reuestIndex = 0 //翻页
//    var isRreshing : Bool = false
    var hideNavigationBar:Bool = false
    var isCurrentRequest : Bool = false // 记录当前页面是否网络请求过，区别是第一次进网络请求，还是下拉刷新进入网络请求
    
    lazy var rightNagationItem:WOWRightNavigationItem = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWRightNavigationItem.self), owner: self, options: nil)?.last as! WOWRightNavigationItem
        view.newView.setCornerRadius(radius: 4)
        view.buyCarButton.addTarget(self, action: #selector(toVCCart), for: .touchUpInside)
        view.infoButton.addTarget(self, action: #selector(toVCMessageCenter), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "line")

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endPageView()
//        UIApplication.shared.keyWindow?.endEditing(true)
    }

    func beginPageView() {
        //TalkingData统计页面
        TalkingData.trackPageBegin( self.title )
        //友盟统计页面
        MobClick.beginLogPageView(self.title)
    }
    
    func endPageView() {
        //TalkingData统计页面
        TalkingData.trackPageEnd( self.title )
        
        MobClick.endLogPageView(self.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginPageView()

        setCustomerBack()
        if hideNavigationBar {
            //设置导航栏透明
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }

    }
    deinit {
        DLog("\(self.title) --- 销毁")
    }
    func setCustomerBack() {
        if navigationController?.viewControllers.count > 1 {
            let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.plain, target: self, action:#selector(navBack))
            navigationItem.leftBarButtonItem = item
        }
    }
    
    func navBack() {
      _ = navigationController?.popViewController(animated: true)
    }

    
    
    func setUI(){
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.tableView.separatorColor = SeprateColor
    }

    func request(){
        if isCurrentRequest == false{
            WOWHud.showLoading()
            isCurrentRequest = true
        }
    }
}


extension WOWBaseTableViewController{
    @objc(titleForEmptyDataSet:) func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = WOWEmptyNoDataText
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    @objc(backgroundColorForEmptyDataSet:) func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return GrayColorLevel5
    }
//    
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "placeholder_instagram")
//    }
}
