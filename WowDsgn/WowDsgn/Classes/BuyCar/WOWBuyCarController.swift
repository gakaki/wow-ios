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
    private var dataArr = [WOWBuyCarModel](){
        didSet{
            if dataArr.isEmpty {
                navigationItem.title = "购物车"
                bottomView.hidden = true
                rightItemButton.hidden = true
            }else{
                navigationItem.title = "购物车\(dataArr.count)"
                bottomView.hidden = false
                rightItemButton.hidden = false
            }
        }
    }
    //存放选中的数组
    private var selectedArr = [WOWBuyCarModel](){
        didSet{
            if isEditing == false{ //不在编辑中,每选中一个就得计算价钱
               let prices = selectedArr.map({ (model) -> String in
                    return model.skuProductPrice
               })
                let counts = selectedArr.map({ (model) -> Int in
                    return model.skuProductCount
                })
                let result = WOWCalPrice.calTotalPrice(prices,counts:counts)
                totalPriceLabel.text = "¥ " + result
            }
        }
    }
    
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endEditButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
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
        configData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Lazy
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight))
        return v
    }()
    
    lazy var buyView:WOWGoodsBuyView = {
        let v = NSBundle.loadResourceName(String(WOWGoodsBuyView)) as! WOWGoodsBuyView
        return v
    }()
    
//MARK:Private Method
    
    private func configData(){
        if WOWUserManager.loginStatus { //登录
            asyncCarList()
        }else{//未登录
            asyncCarNoLogin()
        }
    }
    
    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sureButton(_:)), name: WOWGoodsSureBuyNotificationKey, object:nil)
    }
    
    func sureButton(nf:NSNotification)  {
        backView.hideBuyView()
    }

    override func setUI() {
        super.setUI()
        totalPriceLabel.text = "¥ 0.0"
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
        navigationItem.title = "购物车"
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
        allButton.selected = false
        selectedArr = []
        tableView.reloadData()
        
    }
    
    @IBAction func endButtonClick(sender: UIButton) {
        if isEditing { //删除
            if selectedArr.isEmpty {
                WOWHud.showMsg("您还没有选中商品哦")
                return
            }
            removeCarItem(selectedArr)
        }else{ //结算
            if  WOWUserManager.loginStatus {
                let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWSureOrderController") as! WOWSureOrderController
                navigationController?.pushViewController(sv, animated: true)
            }else{
                goLogin()
            }
        }
    }
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }
    
//MARK:全选按钮点击
    @IBAction func allButtonClick(sender: UIButton) {
        sender.selected = !sender.selected
        for index in 0..<dataArr.count {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if sender.selected {//全选
                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                selectedArr = []
                selectedArr.appendContentsOf(dataArr)
            }else{//全不选
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                selectedArr = []
            }
        }
    }
    
//MARK Network 删除购物车
    /**
     1.没登录的时候，同步本地的购物车数据，防止失效商品的出现
     */
    private func asyncCarNoLogin(){
        //走本地数据库，但是需要同步商品的最新信息
        let objects = WOWRealm.objects(WOWBuyCarModel)
        guard !objects.isEmpty else{
            return
        }
        var param = [AnyObject]()
        for obj in objects {
            let dict = ["skuid":obj.skuID,"count":obj.skuProductCount,"productid":obj.productID]
            param.append(dict)
        }
        let string = JSONStringify(param)
        WOWNetManager.sharedManager.requestWithTarget(.Api_CarNologin(cart:string), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let array = Mapper<WOWBuyCarModel>().mapArray(result)
                if let a = array{
                    strongSelf.dataArr.appendContentsOf(a)
                }
                strongSelf.tableView.reloadData()
            }
            }, failClosure: { (errorMsg) in
                
        })
    }
    
    
    /**
     2.同步登录之后个人购物车的数据，同时合并自己本地保存的购物车数据
     */
    private func asyncCarList(){
        //1.若本地有数据，那就进行同步,否则走第二步
        //2.直接拉取服务器端购物车数据
        let uid = WOWUserManager.userID
        var cars = [AnyObject]()
        var param:[String:AnyObject] = ["uid":uid]
        let objects = WOWRealm.objects(WOWBuyCarModel)
        if objects.isEmpty {
            let string = JSONStringify(param)
            WOWNetManager.sharedManager.requestWithTarget(.Api_CarList(cart:string), successClosure: {[weak self](result) in
                if let strongSelf = self{
                    let array = Mapper<WOWBuyCarModel>().mapArray(result)
                    if let a = array{
                        strongSelf.dataArr.appendContentsOf(a)
                        strongSelf.tableView.reloadData()
                    }
                }
                }, failClosure: { (errorMsg) in
                    
            })
        }else{
            for obj in objects {
                let dict = ["skuid":obj.skuID,"count":obj.skuProductCount,"productid":obj.productID]
                cars.append(dict)
            }
            param["cart"] = cars
            let string = JSONStringify(param)
            WOWNetManager.sharedManager.requestWithTarget(.Api_CarList(cart:string), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    let array = Mapper<WOWBuyCarModel>().mapArray(result)
                    if let a = array{
                        strongSelf.dataArr.appendContentsOf(a)
                        try! WOWRealm.write({
                            WOWRealm.delete(objects)
                        })
                        strongSelf.tableView.reloadData()
                    }
                }
                }, failClosure: { (errorMsg) in
                    
            })
        }
    }
    
    /**
     3.删除购物车数据
     
     - parameter items:
     */
    private func asyncCarDelete(items:[WOWBuyCarModel]){
        let uid = WOWUserManager.userID
        var cars = [AnyObject]()
        var param:[String:AnyObject] = ["uid":uid]
        for obj in items {
            let dict = ["skuid":obj.skuID,"count":obj.skuProductCount,"productid":obj.productID]
            cars.append(dict)
        }
        param["cart"] = cars
        let string = JSONStringify(param)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_CarDelete(cart:string), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                //若删除成功，我就把它从dataArr里面干掉吧
                strongSelf.removeObjectsInArray(items)
                strongSelf.tableView.reloadData()
            }
        }) { (errorMsg) in
                
        }
    }
    
    private func removeObjectsInArray(items:[WOWBuyCarModel]){
        for item in items{
            if let index = self.dataArr.indexOf({$0 == item}){
                self.dataArr.removeAtIndex(index)
            }
        }
    }
    

    private func removeCarItem(items:[WOWBuyCarModel]){
        if WOWUserManager.loginStatus { //登录
            asyncCarDelete(items)
        }else{ //未登录
            try! WOWRealm.write({
                WOWRealm.delete(items)
            })
            self.removeObjectsInArray(items)
            self.tableView.reloadData()
        }
    }
    
//MARK:Private Network
    override func request() {
        super.request()
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
            cell.showData(dataArr[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellNormalID, forIndexPath: indexPath) as! WOWBuyCarNormalCell
            cell.showData(dataArr[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        selectedArr.append(model)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        let index = selectedArr.indexOf{
            $0 == model
        }
        if let i = index {
            selectedArr.removeAtIndex(i)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return isEditing ? 128 : 108
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            try! WOWRealm.write({
                WOWRealm.delete(dataArr[indexPath.row])
            })
            dataArr.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //FIXME:后期应该根据服务器端返回再删除
            if dataArr.isEmpty {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        allButton.selected = false
        selectedArr = []
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    override func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "buycar_none")
    }
    
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "您的购物车是空的"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    
}

extension WOWBuyCarController:CarEditCellDelegate{
    func carEditCellAction() { //选择规格
        navigationController?.view.addSubview(backView)
        navigationController?.view.bringSubviewToFront(backView)
        backView.show()
    }
}




