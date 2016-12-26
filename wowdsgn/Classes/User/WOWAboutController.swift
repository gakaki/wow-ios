//
//  WOWAboutController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAboutController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellId = "WOWAboutCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CheackAppVersion.cheackResult ?? 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        navigationItem.title = "关于尖叫"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.nibName(String(describing: WOWAboutCell.self)), forCellReuseIdentifier: "WOWAboutCell")
        tableView.backgroundColor = GrayColorLevel5
        tableView.separatorColor = SeprateColor

    }
}
extension WOWAboutController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CheackAppVersion.cheackResult == 2 {
            if section == 0 {
                return 1
            }
        }
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWAboutCell", for:indexPath) as! WOWAboutCell
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (0,0): //当前版本
            cell.titleLabel.text = "当前版本"
            cell.arrowImg.isHidden = true
            cell.space.constant = 15
            cell.versionLabel.text = ez.appVersion ?? "检测不到版本"
            break
        case (0,1): //支持尖叫设计
            cell.titleLabel.text = "新版本更新"
            cell.arrowImg.isHidden = false
            cell.space.constant = 31
            var showStr = ""
            switch CheackAppVersion.cheackResult ?? 0 {
            case 0:
                showStr = "已经是最新版"
            case 1:
                showStr = CheackAppVersion.NewestVersion ?? ""
            case 2:
                showStr = "已经是最新版"
            default:
                break
            }
            cell.versionLabel.text = showStr
            cell.lineView.isHidden = true
            break
        case (1,0): //帮助与反馈
            cell.titleLabel.text = "意见反馈"
            cell.arrowImg.isHidden = false
            break
        case (1,1): //支持尖叫设计
            cell.titleLabel.text = "给我们打分"
            cell.arrowImg.isHidden = false
            cell.lineView.isHidden = true
            break
        default:
            break
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (0,0): //当前版本
            
            break
        case (0,1): //支持尖叫设计
            
            switch CheackAppVersion.cheackResult ?? 0 {
          
            case 1:
                 GoToItunesApp.show()
        
            default:
                break
            }
        case (1,0): //帮助与反馈
            goLeavaTips()
            break
        case (1,1): //支持尖叫设计
            GoToItunesApp.show()
            break
        default:
            break
        }
    }
    
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    fileprivate func evaluateApp(){
        GoToItunesApp.show()

    }

}
