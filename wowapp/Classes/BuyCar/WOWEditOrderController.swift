//
//  WOWEditOrderController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWEditOrderController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var productArr                      :[WOWCarProductModel]!
    var totalPrice                      : String?
    

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
        navigationItem.title = "编辑订单"
        totalPriceLabel.text = "¥ " + (totalPrice ?? "")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWAddressCell)), forCellReuseIdentifier:String(WOWAddressCell))
        tableView.registerNib(UINib.nibName(String(WOWValue1Cell)), forCellReuseIdentifier:String(WOWValue1Cell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.registerNib(UINib.nibName(String(WOWTipsCell)), forCellReuseIdentifier:String(WOWTipsCell))
        tableView.registerNib(UINib.nibName(String(WOWValue2Cell)), forCellReuseIdentifier:String(WOWValue2Cell))
        tableView.keyboardDismissMode = .OnDrag
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), animated: true, scrollPosition: .None)
    }
    

}
