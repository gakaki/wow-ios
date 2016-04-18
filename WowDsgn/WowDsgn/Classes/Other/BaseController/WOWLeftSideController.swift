//
//  WOWLeftSideController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/2.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

@objc protocol LeftSideProtocol{
    func sideMenuSelect(tagString:String!,index:Int)
}

class WOWLeftSideController: UIViewController {
    let cellID = String(WOWMenuCell)
    var dataArr = [WOWCategoryModel]()
    weak var delegate:LeftSideProtocol?
    //FIXME:默认应该为全部的额
    var selectedTag:String! = ""
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK:Private Method
    
    private func setUI(){
        tableView.clearRestCell()
        let imageView = UIImageView(frame:CGRectMake(0,0,tableView.width,tableView.height))
        imageView.image = UIImage(named: "menuTableView")
        self.tableView.backgroundView = imageView
    }
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateCategory), name:WOWCategoryUpdateNotificationKey, object: nil)
    }
    
//MARK:Lazy
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
    
//MARK:Actions
    func updateCategory() {
        let categorys = WOWRealm.objects(WOWCategoryModel)
        dataArr = []
        for model in categorys {
            dataArr.append(model)
        }
        tableView.reloadData()
         NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.appdelegate.sideController.hideSide()
    }
    
    func closeButtonClick(){
        self.appdelegate.sideController.hideSide()
    }
}

//MARK:Delegate
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
        cell.showDataModel(dataArr[indexPath.row],isStore:false)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        self.selectedTag = model.categoryID
        self.appdelegate.sideController.hideSide()
        if let dele = self.delegate{
            dele.sideMenuSelect(selectedTag,index: indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return topSectionHeaderView
    }
    
    
}