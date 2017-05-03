//
//  WOWActitvityDetailController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWActitvityDetailController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let titleCellID = "WOWWorksTitleCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setUI() {
        super.setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexColor = GrayColorlevel1
        tableView.mj_header = mj_header
        tableView.mj_footer = mj_footer
        tableView.clearRestCell()
        tableView.register(UINib.nibName(titleCellID), forCellReuseIdentifier:titleCellID)
        
    }
    
    override func loadMore() {
        
    }
    
    //MARK: -- NET
    override func request() {
        super.request()
    }
    
    func requestTitle() {
        
    }
    
    func requestWorks() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension WOWActitvityDetailController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell                = tableView.dequeueReusableCell(withIdentifier: titleCellID, for: indexPath) as! WOWWorksTitleCell
            return cell

        
        
    }
    
}
