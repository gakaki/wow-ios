//
//  WOWBrandDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit



class WOWBrandDetailController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var effectView:UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method-
    override func setUI() {
        super.setUI()
        configTableBackView()
    }
    
    private func configTableBackView(){
        let imageView = UIImageView(frame:tableView.bounds)
        //FIXME:测试
        imageView.image = UIImage(named: "testBrandBack")
        effectView = UIVisualEffectView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight - 35))
        let blurEffect = UIBlurEffect(style: .Light)
        effectView.effect = blurEffect
        effectView.alpha = 0.1
        imageView.addSubview(effectView)
        tableView.backgroundView = imageView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let headerView = WOWBrandHeadView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenWidth * 215/375))
        headerView.backImageView.hidden = true
        headerView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = headerView
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
         cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = ""
        return cell
    }
}

extension WOWBrandDetailController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        effectView.alpha = scrollView.contentOffset.y / scrollView.contentSize.height
    }
}
