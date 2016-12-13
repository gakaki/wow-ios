//
//  WOWMessageInfoController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageInfoController: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    
    let pageSize        = 10
    var msgType: Int?
    
    let cellID = String(describing: WOWMessageInfoCell.self)
    
    
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
        
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier: cellID)
        
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageList(msgType: 1, pageSize: pageSize, currentPage: pageIndex), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                
                strongSelf.endRefresh()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }
    
}
extension WOWMessageInfoController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMessageInfoCell
        
        return cell
    }
    
}
