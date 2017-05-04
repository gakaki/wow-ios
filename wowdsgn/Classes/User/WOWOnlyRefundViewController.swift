//
//  WOWOnlyRefundViewController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOnlyRefundViewController: WOWBaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "仅退款"
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        tableView.backgroundColor = GrayColorLevel5
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(UINib.nibName("WOWGoodsTypeCell"), forCellReuseIdentifier: "WOWGoodsTypeCell")
        tableView.register(UINib.nibName("WOWRefundReasonCell"), forCellReuseIdentifier: "WOWRefundReasonCell")
        tableView.register(UINib.nibName("WOWRefundTextCell"), forCellReuseIdentifier: "WOWRefundTextCell")
        
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWGoodsTypeCell", for: indexPath) as! WOWGoodsTypeCell
            
            return cell
        case 1:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundReasonCell", for: indexPath) as! WOWRefundReasonCell
            
            return cell
        case 2:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWGoodsTypeCell", for: indexPath) as! WOWGoodsTypeCell
            cell.lbGoodsType.text   = "退款金额"
            cell.lbType.text        = "298.00"
            return cell
            
        default:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundTextCell", for: indexPath) as! WOWRefundTextCell
//            cell.lbGoodsType.text   = "退款金额"
//            cell.lbType.text        = "298.00"
            cell.collectionView.isHidden = true
            return cell
            
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
