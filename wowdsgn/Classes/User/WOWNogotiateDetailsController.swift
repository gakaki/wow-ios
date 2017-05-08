//
//  WOWNogotiateDetailsController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWNogotiateDetailsController: WOWBaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "协商详情"
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        
        tableView.backgroundColor = GrayColorLevel5
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(UINib.nibName("WOWNegotiateDetailCell"), forCellReuseIdentifier: "WOWNegotiateDetailCell")

        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 150
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWNegotiateDetailCell", for: indexPath) as! WOWNegotiateDetailCell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        VCRedirect.goOnlyRefund()
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
