//
//  WOWWorksActivityController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksActivityController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let titleCellID = "WOWWorksTitleCell"
    let allCellID = "WOWWorksAllCell"

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
        tableView.register(UINib.nibName(allCellID), forCellReuseIdentifier: allCellID)

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
extension WOWWorksActivityController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }else {
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell                = tableView.dequeueReusableCell(withIdentifier: titleCellID, for: indexPath) as! WOWWorksTitleCell
            return cell
        }else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: allCellID, for: indexPath) as! WOWWorksAllCell
            return cell
        }

        
    }

}
