//
//  WOWOrderTransController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWOrderTransController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = "查看物流"
        tableView.clearRestCell()
        tableView.register(UINib.nibName("WOWTransLineCell"), forCellReuseIdentifier:"WOWTransLineCell")
    }
    
}

extension WOWOrderTransController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWTransLineCell", for: indexPath) as! WOWTransLineCell
        cell.topLine.isHidden = (indexPath as NSIndexPath).row == 0
        cell.spotView.backgroundColor = indexPath.row == 0 ? UIColor.red : MGRgb(128, g: 128, b: 128)
        //FIXME:测试数据
        cell.desLabel.text = "快递到达上海市尖叫公司快递到达上海市尖叫公司快递到达上海市尖叫公司快递到达上海市尖叫公司快递到达上海市尖叫公司快递到达上海市尖叫公司"
        cell.timeLabel.text = "2015-10-12"
        return cell
    }
}
