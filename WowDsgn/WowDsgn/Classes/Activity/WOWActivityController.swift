//
//  WOWActivityController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/2.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWActivityController: WOWBaseViewController {
    let cellID = String(WOWActivityListCell)
    var dataArr = [WOWActivityModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.registerNib(UINib.nibName(String(WOWActivityListCell)), forCellReuseIdentifier:cellID)
    }
    
//MARK:Private Network
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Activity, successClosure: { [weak self](result) in
            if let strongSelf = self{
                let actArr = Mapper<WOWActivityModel>().mapArray(result)
                if let arr = actArr{
                    strongSelf.dataArr.appendContentsOf(arr)
                    strongSelf.tableView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
}

extension WOWActivityController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWActivityListCell
        let model = dataArr[indexPath.row]
        let imageUrl = NSURL(string:model.image ?? "")
        //FIXME:默认图
        cell.pictureImageView.kf_setImageWithURL(imageUrl!, placeholderImage:nil)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        let vc = UIStoryboard.initialViewController("Activity", identifier:"WOWActivityDetailController") as! WOWActivityDetailController
        vc.url = model.url
        navigationController?.pushViewController(vc, animated: true)
    }
}
