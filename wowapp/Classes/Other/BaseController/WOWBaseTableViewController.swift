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
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setCustomerBack()
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

    
    
    func setUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        self.tableView.separatorColor = SeprateColor
    }

    func request(){
        
    }
}


extension WOWBaseTableViewController{
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = WOWEmptyNoDataText
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return GrayColorLevel5
    }
//    
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "placeholder_instagram")
//    }
}
