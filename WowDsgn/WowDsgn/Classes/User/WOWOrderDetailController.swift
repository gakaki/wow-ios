//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWOrderDetailController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
    }
    
    private func configTableView(){
        tableView.estimatedRowHeight = 80
        tableView.registerNib(UINib.nibName("WOWBuyCarNormalCell"), forCellReuseIdentifier: "WOWBuyCarNormalCell")
        tableView.registerNib(UINib.nibName("WOWAddressCell"), forCellReuseIdentifier: "WOWAddressCell")
        tableView.registerNib(UINib.nibName("WOWOrderTransCell"), forCellReuseIdentifier: "WOWOrderTransCell")
    }
    
    
    @IBAction func rightButtonClick(sender: UIButton) {
        DLog("按钮点击啦")
    }
}


extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //订单
            return 2
        case 1: //收货人
            return 1
        case 2: //商品清单
            return 3
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 56
        case 1:
            return 64
        case 2:
            return 108
        default:
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderTransCell", forIndexPath: indexPath) as! WOWOrderTransCell
            cell.accessoryType = indexPath.row == 1 ? .DisclosureIndicator : .None
            cell.statusLabel.hidden = indexPath.row == 1 ? true : false
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWAddressCell", forIndexPath: indexPath) as! WOWAddressCell
                cell.checkButton.hidden = true
            returnCell = cell
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWBuyCarNormalCell", forIndexPath: indexPath) as! WOWBuyCarNormalCell
            cell.hideLeftCheck()
            cell.checkButton.hidden = true
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1{//物流
                let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderTransController") as! WOWOrderTransController
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        default:
            return 41
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = [" ","收货人","商品清单"]
        return titles[section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
    
    
    
    
}
