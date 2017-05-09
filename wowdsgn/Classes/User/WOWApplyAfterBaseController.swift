//
//  WOWApplyAfterBaseController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/9.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWApplyAfterBaseController: WOWBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight), style: .grouped)
        tableView.backgroundColor   = GrayColorLevel5
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorStyle    = .none
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 60
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self {
                make.top.bottom.left.right.equalTo(strongSelf.view)
            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
