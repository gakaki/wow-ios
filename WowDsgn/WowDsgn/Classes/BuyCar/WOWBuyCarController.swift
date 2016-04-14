//
//  WOWBuyCarController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBuyCarController: WOWBaseViewController {
    let cellNormalID = String(WOWBuyCarNormalCell)
    let cellEditID   = String(WOWBurCarEditCell)
    private var rightItemButton:UIButton!
    //FIXME:测试数据
    private var dataArr = ["1","1","1","1","1","1","1","1","1","1","1"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endEditButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    private var isEditing:Bool = false{
        didSet{
            totalLabel.hidden = isEditing
            totalPriceLabel.hidden = isEditing
            endButton.selected = isEditing
            if isEditing {
                endButton.backgroundColor = UIColor.redColor()
            }else{
                endButton.backgroundColor = ThemeColor
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Lazy
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight - 64))
        return v
    }()
    
    lazy var buyView:WOWGoodsBuyView = {
        let v = NSBundle.loadResourceName(String(WOWGoodsBuyView)) as! WOWGoodsBuyView
        return v
    }()
    
//MARK:Private Method
    
    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sureButton(_:)), name: WOWGoodsSureBuyNotificationKey, object:nil)
    }
    
    func sureButton(nf:NSNotification)  {
        let object = nf.object as? PostBuyModel
        if let model = object {
            DLog("确定的东东\(model.count),另外\(model.typeStrng)")
        }
        backView.hideBuyView()
    }

    
    
    override func setUI() {
        super.setUI()
        endButton.setTitle("删除", forState:.Selected)
        endButton.setTitle("去结算", forState:.Normal)
        endButton.tintColor = UIColor.clearColor()
        
        configNav()
        configTable()
    }
    
    
    private func configTable(){
        tableView.registerNib(UINib.nibName(String(WOWBuyCarNormalCell)), forCellReuseIdentifier:cellNormalID)
        tableView.registerNib(UINib.nibName(String(WOWBurCarEditCell)), forCellReuseIdentifier:cellEditID)
        tableView.clearRestCell()
    }
    
    private func configNav(){
        //FIXME:测试数据
        navigationItem.title = "购物车\(22)"
        makeCustomerImageNavigationItem("closeNav_white", left:true) {[weak self] in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        rightItemButton = UIButton(type: .System)
        rightItemButton.contentHorizontalAlignment = .Right
        rightItemButton.frame = CGRectMake(0, 0, 60, 32)
        rightItemButton.setTitle("编辑", forState:.Normal)
        rightItemButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        rightItemButton.titleLabel?.font = Fontlevel002
        rightItemButton.addTarget(self, action: #selector(editButtonClick), forControlEvents:.TouchUpInside)
        let rightItem = UIBarButtonItem(customView:rightItemButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
//MARK:Actions
    func editButtonClick() {
        isEditing = !isEditing
        let title = isEditing ? "完成" : "编辑"
        rightItemButton.setTitle(title, forState:.Normal)
        tableView.reloadData()
    }
    
    @IBAction func endButtonClick(sender: UIButton) {
        if isEditing { //删除
            
        }else{ //结算
            let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWSureOrderController") as! WOWSureOrderController
            navigationController?.pushViewController(sv, animated: true)
        }
    }
    
    @IBAction func allButtonClick(sender: UIButton) {
        
        
    }
}


extension WOWBuyCarController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isEditing{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellEditID, forIndexPath: indexPath) as! WOWBurCarEditCell
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellNormalID, forIndexPath: indexPath) as! WOWBuyCarNormalCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return isEditing ? 128 : 108
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataArr.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
}

extension WOWBuyCarController:CarEditCellDelegate{
    func carEditCellAction() { //选择规格
        view.addSubview(backView)
        view.bringSubviewToFront(backView)
        backView.show()
    }
}




