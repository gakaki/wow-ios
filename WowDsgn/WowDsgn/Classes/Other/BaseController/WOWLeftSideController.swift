//
//  WOWLeftSideController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/2.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

@objc protocol LeftSideProtocol{
    func sideMenuSelect(tagString:String!)
}

class WOWLeftSideController: UIViewController {
    let cellID = String(WOWMenuCell)
    var dataArr = [WOWMenuModel]()
    weak var delegate:LeftSideProtocol?
    //FIXME:默认应该为全部的额
    var selectedTag:String! = ""
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUI(){
        tableView.clearRestCell()
        //tableview 设置毛玻璃效果
//        let blurView = UIVisualEffectView(frame:CGRectMake(0,0,tableView.width,tableView.height))
//        let blurEffect = UIBlurEffect(style: .Light)
//        blurView.effect = blurEffect
//        self.tableView.backgroundView = blurView
        let imageView = UIImageView(frame:CGRectMake(0,0,tableView.width,tableView.height))
        imageView.image = UIImage(named: "menuTableView")
        self.tableView.backgroundView = imageView
    }
    
    private func initData(){
        //FIXME:估计后期是要做成活的咯
        let images = ["all","jiashi","dengguang","zhuangdian","shiju","tongqu"]
        let names  = WOWMenus
        let tags   = ["0","1","2","3","4","5"]
        let count  = [111,222,333,444,555,666]
        for index in 0..<images.count{
            let model = WOWMenuModel(imageName:images[index], name: names[index], count: count[index],tag:tags[index])
            dataArr.append(model)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.appdelegate.sideController.hideSide()
    }
    
    lazy var appdelegate:AppDelegate = {
        let a =  UIApplication.sharedApplication().delegate as! AppDelegate
        return a
    }()
    
    lazy var topSectionHeaderView:UIView = {
        var view = UIView(frame:CGRectMake(0,0,MGScreenWidth,64))
        let menuView = WOWMenuTopView(frame:CGRectMake(0,24,self.tableView.width,40))
        menuView.rightButton.addTarget(self, action: #selector(WOWLeftSideController.closeButtonClick), forControlEvents:.TouchUpInside)
        menuView.backgroundColor = UIColor.clearColor()
        view.addSubview(menuView)
        return view
    }()
    
    func closeButtonClick(){
        self.appdelegate.sideController.hideSide()
    }
}


extension WOWLeftSideController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! WOWMenuCell
        cell.backgroundColor = UIColor.clearColor()
        cell.showDataModel(dataArr[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        self.selectedTag = model.menuTag
        self.appdelegate.sideController.hideSide()
        if let dele = self.delegate{
            dele.sideMenuSelect(selectedTag)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return topSectionHeaderView
    }
    
    
}