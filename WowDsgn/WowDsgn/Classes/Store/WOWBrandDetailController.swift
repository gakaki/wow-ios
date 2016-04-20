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
    var effectView:UIVisualEffectView!
    
    
    
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
        //FIXME:测试
        imageView.image = UIImage(named: "testBrandBack")
        effectView = UIVisualEffectView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight - 35))
        let blurEffect = UIBlurEffect(style: .Light)
        effectView.effect = blurEffect
        effectView.alpha = 0.1
        imageView.addSubview(effectView)
        
        let shadownView = UIView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight - 35))
        shadownView.backgroundColor = UIColor.lightGrayColor()
        shadownView.alpha = 0.3
        imageView.addSubview(shadownView)
        
        tableView.backgroundView = imageView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let headerView = WOWBrandHeadView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenWidth * 215/375))
        headerView.nameLabel.font = UIFont.mediumScaleFontSize(21)
        headerView.nameLabel.shadowColor = MGRgb(0, g: 0, b: 0, alpha: 0.5)
        headerView.nameLabel.text = brandModel.brandName
        headerView.headImageView.kf_setImageWithURL(NSURL(string:brandModel.brandImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
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
        cell.desTextLabel?.text = brandModel.brandDesc
        cell.desTextLabel.shadowColor = MGRgb(0, g: 0, b: 0, alpha: 0.2)
        cell.desTextLabel.shadowOffset = CGSizeMake(1, 1)
        return cell
    }
}

extension WOWBrandDetailController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        effectView.alpha = scrollView.contentOffset.y / scrollView.contentSize.height
    }
}

extension WOWBrandDetailController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            DLog("喜欢")
        case WOWItemActionType.Share.rawValue:
            DLog("分享")
        default:
            DLog("")
        }

    }
}
