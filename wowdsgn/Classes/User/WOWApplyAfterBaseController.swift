//
//  WOWApplyAfterBaseController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/9.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
// tableView 基类   只有tableView  统一group风格，无分割线
class WOWApplyAfterBaseController: WOWBaseViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView: UITableView!
    var bottomView: UIView! // 底部View  高 50 ，可以自定义定制
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        
        let containerView = UIStackView.init(frame: CGRect.init(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight - 64))
        containerView.axis = UILayoutConstraintAxis.vertical
        containerView.alignment = UIStackViewAlignment.fill
        containerView.distribution = UIStackViewDistribution.fill

        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight), style: .grouped)
        tableView.backgroundColor   = GrayColorLevel5
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorStyle    = .none
        tableView.mj_header          = mj_header
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 60

        
        bottomView = UIView.init()
        bottomView.backgroundColor = UIColor.white
        containerView.addArrangedSubview(tableView)
        containerView.addArrangedSubview(bottomView)
        
        self.view.addSubview(containerView)
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        bottomView.isHidden = true // 默认隐藏， 
        
        
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
