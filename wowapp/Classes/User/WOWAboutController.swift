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
    @IBOutlet weak var protocolView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        navigationItem.title = "关于"
        view.backgroundColor = MGRgb(250, g: 250, b: 250)
        protocolView.addAction {[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("User", identifier:"WOWCopyrightController") as! WOWCopyrightController
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
