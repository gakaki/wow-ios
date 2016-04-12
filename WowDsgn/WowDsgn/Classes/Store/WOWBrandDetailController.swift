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
        headerView.nameLabel.shadowOffset = CGSizeMake(1, 1)
        headerView.backImageView.hidden = true
        headerView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = headerView
        tableView.registerNib(UINib.nibName(String(WOWBrandDetailCell)), forCellReuseIdentifier:cellID)
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
        //FIXME:测试
        cell.desTextLabel?.text = testString
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




let testString = "Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。\nCarl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。\nCarl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。\nCarl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。\nCarl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。\nCarl Hansen & Son是丹麦历史最悠久的家具制造商之一。1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。Carl Hansen & Son是丹麦历史最悠久的家具制造商之一。\n1908年成立，总部设立在丹麦的Aarup。Carl Hansen & Son公司缘起于1908年Carl Hansen先生创立他的橱柜制造工作室开始。"