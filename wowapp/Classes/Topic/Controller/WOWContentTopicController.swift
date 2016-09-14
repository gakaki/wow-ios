//
//  WOWContentTopicController.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWContentTopicController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension WOWContentTopicController: UITableViewDelegate, UITableViewDataSource {
    func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        //显示价格的cell
        tableView.registerNib(UINib.nibName(String(WOWContentTopicTopCell)), forCellReuseIdentifier:String(WOWContentTopicTopCell))
               //相关商品
        tableView.registerNib(UINib.nibName(String(WOWProductDetailAboutCell)), forCellReuseIdentifier:String(WOWProductDetailAboutCell))
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch (indexPath.section,indexPath.row) {
        case (0,_): //标题价钱
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWContentTopicTopCell), forIndexPath: indexPath) as! WOWContentTopicTopCell
            returnCell = cell
        case (1,_)://相关商品
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailAboutCell", forIndexPath: indexPath) as! WOWProductDetailAboutCell
            returnCell = cell
        default:
            break
        }
        return returnCell
    }

}