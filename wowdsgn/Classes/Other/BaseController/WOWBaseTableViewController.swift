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
    var carBadgeCount: MIBadgeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "line")

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomerBack()
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
