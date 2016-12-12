//
//  WOWMessageViewController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageController: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    
    let cellID = String(describing: WOWMessageCenterCell.self)


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
        configBuyBarItem()
        //隐藏消息按钮
        rightNagationItem.infoButton.isHidden = true
        rightNagationItem.newView.isHidden = true
        
        tableView.mj_header = self.mj_header
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.estimatedRowHeight = 130
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier: cellID)

    }
    override func request() {
        super.request()
        
    }

}
extension WOWMessageController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMessageCenterCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转消息中心
            let vc = UIStoryboard.initialViewController("Message", identifier:String(describing: WOWMessageInfoController.self)) as! WOWMessageInfoController
            vc.hideNavigationBar = false
            pushVC(vc)
    }
    
    //MARK: - EmptyData
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_message_icon")
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "还没有消息"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(74, g: 74, b: 74),NSFontAttributeName:UIFont.systemScaleFontSize(14)])
        return attri
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    
}
