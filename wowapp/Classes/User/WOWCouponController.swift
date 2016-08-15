//
//  WOWCouponController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/15.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

enum couponEntrance {
    case userEntrance
    case orderEntrance
}

class WOWCouponController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var entrance = couponEntrance.userEntrance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "优惠券"
        tableView.registerNib(UINib.nibName(String(WOWCouponCell)), forCellReuseIdentifier: "WOWCouponCell")
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWCouponController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWCouponCell", forIndexPath:indexPath) as! WOWCouponCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if entrance == .userEntrance {
                return 15
            }else {
                return 90
            }
        default:
            return 15
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if entrance == .userEntrance {
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                return view
            }else {
                let view = NSBundle.mainBundle().loadNibNamed(String(WOWCouponheaderView), owner: self, options: nil).last as! WOWCouponheaderView
                return view
            }
        default:
            let view = UIView()
            view.backgroundColor = UIColor.clearColor()
            return view
        }
    }
}
