//
//  WOWBrandDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit





class WOWBrandDetailController: WOWBaseViewController {
    private let cellID = "WOWBrandDetailCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var underView: WOWBrandUnderView!
    var brandModel:WOWBrandModel!
//    var effectView:UIVisualEffectView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        underView.delegate = self
        configTableView()
    }
    
    private func configTableView(){
        let imageView = UIImageView(frame:tableView.bounds)
        imageView.image = UIImage(named: "brandBack")
        tableView.backgroundView = imageView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let headerView = WOWBrandHeadView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenWidth * 215/375))
        headerView.nameLabel.font = UIFont.mediumScaleFontSize(21)
        headerView.nameLabel.text = brandModel.name
        headerView.headImageView.kf_setImageWithURL(NSURL(string:brandModel.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        headerView.nameLabel.shadowOffset = CGSizeMake(1, 1)
        headerView.backImageView.hidden = true
        headerView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = headerView
        tableView.registerNib(UINib.nibName(String(WOWBrandDetailCell)), forCellReuseIdentifier:cellID)
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion:nil)
    }
}

extension WOWBrandDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWBrandDetailCell
        cell.desTextLabel.textColor = MGRgb(0, g: 0, b: 0, alpha: 0.5)
        cell.desTextLabel?.text = brandModel.desc
//        cell.desTextLabel.shadowColor = MGRgb(0, g: 0, b: 0, alpha: 0.2)
        cell.desTextLabel.shadowOffset = CGSizeMake(1, 1)
        return cell
    }
}

extension WOWBrandDetailController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

extension WOWBrandDetailController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Share.rawValue:
            WOWBrandModel.shareBrand(brandModel.name ?? "", url:brandModel.url ?? "")
        default:
            break
        }
    }
}
