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
//    private var editingModel    : WOWBuyCarModel?
    private var totalPrice      : String?
    
    private var dataArr = [WOWCarProductModel](){
        didSet{
            if dataArr.isEmpty {
                bottomView.hidden = true
            }else{
                bottomView.hidden = false
            }
        }
    }

    //存放选中的数组
    private var selectedArr = [WOWCarProductModel](){
        didSet{
               let prices = selectedArr.map({ (model) -> Double in
                    return model.sellPrice ?? 0
               })
                let counts = selectedArr.map({ (model) -> Int in
                    return model.productQty ?? 0
                })
                let result = WOWCalPrice.calTotalPrice(prices,counts:counts)
                totalPrice = result
                totalPriceLabel.text = "¥ " + result
            if selectedArr.count == dataArr.count {
                allButton.selected = true
            }else{
                allButton.selected = false
            }
        }
    }
    
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    



    
//MARK:Private Method
    private func configData(){
       
        asyncCarList()
        
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "购物车"
        totalPriceLabel.text = "¥ 0.0"
        endButton.setTitle("去结算", forState:.Normal)
        endButton.tintColor = UIColor.clearColor()

        configTable()
    }
    
    
    private func configTable(){
        tableView.registerNib(UINib.nibName(String(WOWBuyCarNormalCell)), forCellReuseIdentifier:cellNormalID)
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor

    }
    
    
    private func updateCarCountBadge(){
        WOWBuyCarMananger.updateBadge()
        NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    

    
//MARK:结算
    @IBAction func endButtonClick(sender: UIButton) {
        if selectedArr.isEmpty {
            WOWHud.showMsg("您还没有选中商品哦")
            return
        }
         //结算
            let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWEditOrderController") as!WOWEditOrderController
            navigationController?.pushViewController(sv, animated: true)
        
    }
    
    
//MARK:全选按钮点击
    @IBAction func allButtonClick(sender: UIButton) {
        //判断全选按钮的状态，如果是全部选中的状态，点击按钮取消全部选中，如果未选中状态，点击按钮则要全部选中
        if sender.selected {
            asynCartUnSelect(dataArr)
          
        }else{
            asyncCartSelect(dataArr)
        }
        
    }
    
    

    
//MARK Network 购物车
    
    /**
     2.同步登录之后个人购物车的数据
     */
    private func asyncCarList(){
        //1.直接拉取服务器端购物车数据
            WOWNetManager.sharedManager.requestWithTarget(.Api_CartGet, successClosure: {[weak self](result) in
                if let strongSelf = self{
                    let model = Mapper<WOWCarModel>().map(result)
                    if let arr = model?.shoppingCartResult {
                        strongSelf.dataArr = arr
                        //判断当前数组有多少默认选中的加入选中的数组
                        for product in strongSelf.dataArr {
                            if product.isSelected ?? false {
                                strongSelf.selectedArr.append(product)
                            }
                        }
                    }
                    
                    strongSelf.updateCarCountBadge()
                    strongSelf.tableView.reloadData()

                }
                }, failClosure: { (errorMsg) in
                    
            })
    }
    
    /**
     3.删除购物车数据
     - parameter items:
     */
    private func asyncCarDelete(model: WOWCarProductModel){
        var shoppingCartId = [Int]()
        shoppingCartId.append(model.shoppingCartId ?? 0)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_CartRemove(shoppingCartId:shoppingCartId), successClosure: {[weak self] (result) in
            if let strongSelf = self{
               strongSelf.dataArr.removeObject(model)
                //判断一下如果删除的商品是已选中商品。那么从selectedArr中也要删除这个元素
                
                if model.isSelected ?? false{
                    strongSelf.selectedArr.removeObject(model)
                }
                strongSelf.tableView.reloadData()
            }
        }) { (errorMsg) in
                
        }
    }
    
    
    /**
     4.更改购物车商品数量
     
     - parameter items:
     */
    private func asyncUpdateCount(shoppingCartId: Int, productQty: Int, indexPath: NSIndexPath){

        WOWNetManager.sharedManager.requestWithTarget(.Api_CartModify(shoppingCartId:shoppingCartId, productQty: productQty), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let model = strongSelf.dataArr[indexPath.section]
                model.productQty = productQty
                strongSelf.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }) { (errorMsg) in
            WOWHud.showMsg("修改失败")
        }
        
    }
    
    /**
     5.购物车内产品选中
     
     - parameter model: 购物车商品model
     */
    private func asyncCartSelect(array: [WOWCarProductModel]) {
        var shoppingCartIdArray = [Int]()
        for carProduct in array {
            shoppingCartIdArray.append(carProduct.shoppingCartId!)
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_CartSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result) in
            if let strongSelf = self {
               
                for index in 0..<strongSelf.dataArr.count {
                    let model = strongSelf.dataArr[index]
                    //判断是全部取消还是逐个取消，如果array.count大于1，则是全部选中，选择状态要都置为true
                    //如果逐个取消，只把选择的那个对象状态置为true
                    if array.count > 1 {
                        strongSelf.selectedArr = []
                        strongSelf.allButton.selected = true
                        model.isSelected = true
                    }else {
                        if model == array[0] {
                            model.isSelected = true
                        }
                    }
                }

                strongSelf.selectedArr.appendContentsOf(array)
                strongSelf.tableView.reloadData()

            }
           

            }) { (errorMsg) in
                
        }
    }
    
    /**
     购物车内产品取消
     
     - parameter model: 购物车商品model
     */
    private func asynCartUnSelect(array: [WOWCarProductModel]) {
        var shoppingCartIdArray = [Int]()
        for carProduct in array {
            shoppingCartIdArray.append(carProduct.shoppingCartId!)
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_CartUnSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result) in
            if let strongSelf = self {
                strongSelf.allButton.selected = false
                //循环遍历传来的数组，逐个从已选中数组中移除掉
                for carProduct in array {
                    strongSelf.selectedArr.removeObject(carProduct)
                }
                for index in 0..<strongSelf.dataArr.count {
                    let model = strongSelf.dataArr[index]
                    //判断是全部取消还是逐个取消，如果array.count大于1，则是全部取消，选择状态要都置为false
                    //如果逐个取消，只把选择的那个对象状态置为false
                    if array.count > 1 {
                        model.isSelected = false
                    }else {
                        if model == array[0] {
                            model.isSelected = false
                        }
                    }
                }
                
                strongSelf.tableView.reloadData()
            }
        }) { (errorMsg) in
            
        }
    
    }

    
    private func removeObjectsInArray(items:[WOWCarProductModel]){
        for item in items{
            if let index = self.dataArr.indexOf({$0 == item}){
                self.dataArr.removeAtIndex(index)
            }
        }
        updateCarCountBadge()
    }
    

    
}


extension WOWBuyCarController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        
            let cell = tableView.dequeueReusableCellWithIdentifier(cellNormalID, forIndexPath: indexPath) as! WOWBuyCarNormalCell
            cell.showData(model)
        
            cell.selectButton.tag = indexPath.section
            cell.selectButton.addTarget(self, action: #selector(selectClick(_:)), forControlEvents: .TouchUpInside)
            cell.subCountButton.tag = indexPath.section
            cell.subCountButton.addTarget(self, action: #selector(subCountClick(_:)), forControlEvents: .TouchUpInside)
            cell.addCountButton.tag = indexPath.section
            cell.addCountButton.addTarget(self, action: #selector(addCountClick(_:)), forControlEvents: .TouchUpInside)
            return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  170
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
                asyncCarDelete(dataArr[indexPath.section])
        }
        
    }
    
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //MARK: - cellAction 
    func selectClick(sender: UIButton) {
        let model = dataArr[sender.tag]
        let select = model.isSelected ?? false
        if select {
            asynCartUnSelect([model])
        }else {
            asyncCartSelect([model])
        }
        
    }
    //添加商品数量
    func addCountClick(sender: UIButton) {
        let model = dataArr[sender.tag]
        var productQty = model.productQty ?? 1
        productQty += 1
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: sender.tag)
        asyncUpdateCount(model.shoppingCartId!, productQty: productQty, indexPath: indexPath)
    }
    //减少商品数量
    func subCountClick(sender: UIButton) {
        let model = dataArr[sender.tag]
            var count = model.productQty ?? 1
            count -= 1
            count = (count == 0 ? 1:count)
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: sender.tag)
        asyncUpdateCount(model.shoppingCartId!, productQty: count, indexPath: indexPath)
    }
    
    //MARK: - EmptyData
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "buycar_none")
    }
    
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "您的购物车是空的"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
}






