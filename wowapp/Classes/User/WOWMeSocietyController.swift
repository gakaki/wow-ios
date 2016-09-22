//
//  WOWMeSocietyController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
 /// 关注我的和我关注的人的列表

enum SocietyType:String {
    case Focus = "关注"
    case Fans  = "粉丝"
}

class WOWMeSocietyController: WOWBaseViewController {
    var society:SocietyType = .Focus
    var dataArr = ["12","3","44","55"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        navigationItem.title = society.rawValue
        tableView.clearRestCell()
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = 66
        tableView.register(UINib.nibName("WOWSocietyCell"), forCellReuseIdentifier:"WOWSocietyCell")
    }
}

extension WOWMeSocietyController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWSocietyCell", for: indexPath) as! WOWSocietyCell
        cell.nameLabel.text = WOWTestStr
        cell.desLabel.text = WOWTestStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWUserHomeController") as! WOWUserHomeController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return society == .Focus
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArr.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消关注"
    }
    
    
}
