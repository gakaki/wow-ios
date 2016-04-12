//
//  WOWLikeListController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWLikeListController: WOWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func setUI() {
        //FIXME:
        self.navigationItem.title = "100人喜欢"
    }
}


extension WOWLikeListController:SenceListCellDelegate{
    func attentionButtonClick() {
        DLog("是否关注按钮被点击")
    }
}

extension WOWLikeListController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWLikeListCell), forIndexPath:indexPath) as! WOWLikeListCell
        cell.delegate  = self
        //FIXME:
        cell.nameLabel.text = "尖叫君"
        cell.headImageView.image = UIImage(named:"testHeadImage")
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 201
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}