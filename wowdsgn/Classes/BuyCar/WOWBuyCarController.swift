//
//  WOWBuyCarController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class WOWBuyCarController: WOWBaseViewController {
    let cellNormalID = String(describing: WOWBuyCarNormalCell.self)
    let cellID = String(describing: WOWOrderCell.self)
//    private var editingModel    : WOWBuyCarModel?
    fileprivate var totalPrice      : String?
    
    var dataArr = [WOWCarProductModel](){
        didSet{
            /**
             *  如果购物车内没有商品底部view就隐藏
             */
            if dataArr.isEmpty {
                bottomView.isHidden = true
            }else{
                bottomView.isHidden = false
            }
        }
    }
    //有效商品的数组
    var validArr = [WOWCarProductModel]()

    //存放选中的数组
    fileprivate var selectedArr = [WOWCarProductModel](){
        didSet{
               let prices = selectedArr.map({ (model) -> Double in
                    return model.sellPrice ?? 0
               })
                let counts = selectedArr.map({ (model) -> Int in
                    return model.productQty ?? 0
                })
            
            //计算价钱
                let result = WOWCalPrice.calTotalPrice(prices,counts:counts)
                totalPrice = result
                totalPriceLabel.text = result
            
            //如果选中的数组数量跟购物车内有效的商品数量相同全选按钮置为选中状态
            if selectedArr.count == validArr.count {
                allButton.isSelected = true
            }else{
                allButton.isSelected = false
            }
        }
    }
    
    
    @IBOutlet weak var allButton: UIButton!             //全选按钮
    @IBOutlet weak var tableView: UITableView!          //购物车列表
    @IBOutlet weak var endButton: UIButton!             //去结算按钮
    @IBOutlet weak var totalPriceLabel: UILabel!        //商品总价
    @IBOutlet weak var bottomView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }
    



    
//MARK:Private Method
    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        
    }
    
    func loginSuccess() {
        configData()
    }
    
    fileprivate func configData(){
       
        asyncCarList()
        
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "购物车"
        totalPriceLabel.text = "¥ 0.00"
        endButton.setTitle("去结算", for:UIControlState())
        endButton.tintColor = UIColor.clear

        configTable()
    }
    
    
    fileprivate func configTable(){
        tableView.register(UINib.nibName(String(describing: WOWBuyCarNormalCell.self)), forCellReuseIdentifier:cellNormalID)
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor

    }
    
    
    fileprivate func updateCarCountBadge(){
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    

    
//MARK:结算
    @IBAction func endButtonClick(_ sender: UIButton) {
        /**
         *  商品结算之前首先判断有没有选中商品，然后判断商品的库存是否充足，再判断所选商品是否下架
         */
        if selectedArr.isEmpty {
            WOWHud.showMsg("您还没有选中商品哦")
            return
        }
        
        for product in selectedArr {
            if product.productStatus == 2 {
                WOWHud.showMsg((product.productName ?? "您有商品") + "已下架")
                return
            }
            if product.productQty > product.productStock {
                WOWHud.showMsg((product.productName ?? "您有商品") + "库存不足")
                return
            }
            
        }
         //结算
            let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWEditOrderController") as!WOWEditOrderController
            sv.entrance = editOrderEntrance.carEntrance
            navigationController?.pushViewController(sv, animated: true)
        
    }
    
    
//MARK:全选按钮点击
    @IBAction func allButtonClick(_ sender: UIButton) {
        //判断全选按钮的状态，如果是全部选中的状态，点击按钮取消全部选中，如果未选中状态，点击按钮则要全部选中
        if sender.isSelected {
            asynCartUnSelect(validArr)
          
        }else{
            asyncCartSelect(validArr)
        }
        
    }
    
    

    
//MARK Network 购物车
    
    /**
     2.同步登录之后个人购物车的数据
     */
    func asyncCarList(){
        //1.直接拉取服务器端购物车数据
            WOWNetManager.sharedManager.requestWithTarget(.api_CartGet, successClosure: {[weak self](result) in
                if let strongSelf = self{
                    let model = Mapper<WOWCarModel>().map(JSONObject:result)
                    if let arr = model?.shoppingCartResult {
                        strongSelf.dataArr = arr
                        strongSelf.bottomView.isHidden = false
                        //重新计算购物车数量
                        WOWUserManager.userCarCount = 0
                        for product in arr {
                            WOWUserManager.userCarCount += product.productQty ?? 1
                            /**
                             *  productStatus 产品状态
                             1 已上架 2已下架
                             
                             如果已下架，isSelect = false
                             */
                            if product.productStatus == 2 {
                                product.isSelected = false
                            }
                        }
                        strongSelf.updateCarCountBadge()
                    
                        
                        //判断当前数组有多少默认选中的加入选中的数组
                        for product in strongSelf.dataArr {
                            
                            if product.productStatus == 1 {
                                strongSelf.validArr.append(product)
                                if product.isSelected ?? false {
                                    strongSelf.selectedArr.append(product)
                                }
                            }
                            
                        }
                    }else {
                        strongSelf.bottomView.isHidden = true
                    }
                    
//                    strongSelf.updateCarCountBadge()
                    strongSelf.tableView.reloadData()

                }
                }, failClosure: { (errorMsg) in
                    
            })
    }
    
    /**
     3.删除购物车数据
     - parameter items:
     */
    func asyncCarDelete(_ model: WOWCarProductModel){
        var shoppingCartId = [Int]()
        shoppingCartId.append(model.shoppingCartId ?? 0)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_CartRemove(shoppingCartId:shoppingCartId), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                strongSelf.dataArr.removeObject(model)
                WOWUserManager.userCarCount -= model.productQty ?? 1
                //更新购物车数量信息
                strongSelf.updateCarCountBadge()
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
    fileprivate func asyncUpdateCount(_ shoppingCartId: Int, productQty: Int, indexPath: IndexPath){

        WOWNetManager.sharedManager.requestWithTarget(.api_CartModify(shoppingCartId:shoppingCartId, productQty: productQty), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let model = strongSelf.dataArr[(indexPath as NSIndexPath).section]
                
                model.productQty = productQty
                //重新计算购物车数量
                WOWUserManager.userCarCount = 0
                for product in strongSelf.dataArr {
                    WOWUserManager.userCarCount += product.productQty ?? 1
                }
                strongSelf.updateCarCountBadge()
                
                if model.isSelected ?? false{
                    strongSelf.selectedArr.removeObject(model)
                    strongSelf.selectedArr.append(model)
                }
                strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }) { (errorMsg) in
            WOWHud.showMsg("修改失败")
        }
        
    }
    
    /**
     5.购物车内产品选中
     
     - parameter model: 购物车商品model
     */
    fileprivate func asyncCartSelect(_ array: [WOWCarProductModel]) {
        var shoppingCartIdArray = [Int]()
        for carProduct in array {
            shoppingCartIdArray.append(carProduct.shoppingCartId!)
        }
        WOWNetManager.sharedManager.requestWithTarget(.api_CartSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result) in
            if let strongSelf = self {
               
                for index in 0..<array.count {
                    let model = array[index]
                    //判断是全部取消还是逐个取消，如果array.count大于1，则是全部选中，选择状态要都置为true
                    //如果逐个取消，只把选择的那个对象状态置为true
                    if array.count > 1 {
                        strongSelf.selectedArr = []
                        strongSelf.allButton.isSelected = true
                        model.isSelected = true
                    }else {
                        if model == array[0] {
                            model.isSelected = true
                        }
                    }
                }

                strongSelf.selectedArr.append(contentsOf: array)
                strongSelf.tableView.reloadData()

            }
           

            }) { (errorMsg) in
                
        }
    }
    
    /**
     购物车内产品取消
     
     - parameter model: 购物车商品model
     */
    fileprivate func asynCartUnSelect(_ array: [WOWCarProductModel]) {
        var shoppingCartIdArray = [Int]()
        for carProduct in array {
            shoppingCartIdArray.append(carProduct.shoppingCartId!)
        }
        WOWNetManager.sharedManager.requestWithTarget(.api_CartUnSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result) in
            if let strongSelf = self {
                strongSelf.allButton.isSelected = false
                //循环遍历传来的数组，逐个从已选中数组中移除掉
                for carProduct in array {
                    strongSelf.selectedArr.removeObject(carProduct)
                }
                for index in 0..<array.count {
                    let model = array[index]
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
}


extension WOWBuyCarController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[(indexPath as NSIndexPath).section]
        //productStatus = 1 已上架，productStatus = 2 已下架
        if model.productStatus == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellNormalID, for: indexPath) as! WOWBuyCarNormalCell
            cell.showData(model)
            cell.selectButton.tag = (indexPath as NSIndexPath).section
            cell.selectButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
            cell.subCountButton.tag = (indexPath as NSIndexPath).section
            cell.subCountButton.addTarget(self, action: #selector(subCountClick(_:)), for: .touchUpInside)
            cell.addCountButton.tag = (indexPath as NSIndexPath).section
            cell.addCountButton.addTarget(self, action: #selector(addCountClick(_:)), for: .touchUpInside)
            cell.delegate = self
            return cell

        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWOrderCell
            cell.showData(model)
            cell.delegate = self
            return cell

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[(indexPath as NSIndexPath).section]
        if model.productStatus == 1 {
            return 160
        }else {
            return  111
        }
    }

    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//                asyncCarDelete(dataArr[indexPath.section])
//        }
//        
//    }
//    
//    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        return "删除"
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self](action, indexPath) in
            if let strongSelf = self {
                
                strongSelf.alertView(strongSelf.dataArr[(indexPath as NSIndexPath).section])
            }
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //MARK: - cellAction
    func selectClick(_ sender: UIButton) {
        let model = dataArr[sender.tag]
        let select = model.isSelected ?? false
        
        if select {
            asynCartUnSelect([model])
        }else {
            asyncCartSelect([model])
        }
        
    }
    
    //添加商品数量
    func addCountClick(_ sender: UIButton) {
        let model = dataArr[sender.tag]
        var productQty = model.productQty ?? 1
        
        if productQty > model.productStock {
            productQty = model.productStock ?? 0
        }else {
            productQty += 1
        }
        let indexPath: IndexPath = IndexPath(row: 0, section: sender.tag)
        asyncUpdateCount(model.shoppingCartId!, productQty: productQty, indexPath: indexPath)
    }
    
    //减少商品数量
    func subCountClick(_ sender: UIButton) {
        let model = dataArr[sender.tag]
            var count = model.productQty ?? 1
        if count > model.productStock  {
//            WOWHud.showMsg("商品可用库存仅剩\(model.productStock)")
            count = model.productStock ?? 0
//            model.productQty = model.productStock
        }else {
            count -= 1
        }
        
        count = (count <= 0 ? 1:count)
        let indexPath: IndexPath = IndexPath(row: 0, section: sender.tag)
        asyncUpdateCount(model.shoppingCartId!, productQty: count, indexPath: indexPath)
    }
    
    //MARK: - EmptyData
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "buyCarEmpty")
    }
    
    func titleForEmptyDataSet(_ scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "您的购物车还是空的\n快去逛逛吧"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(74, g: 74, b: 74),NSFontAttributeName:UIFont.systemScaleFontSize(14)])
        return attri
    }
    
    //MARK: - alertView
    func alertView(_ model: WOWCarProductModel) {
        let alert = UIAlertController(title: "", message: "确定删除此商品？", preferredStyle: .alert)
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: { (action) in
            DLog("取消")
        })
        
        let sure   = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            if let strongSelf = self{
                strongSelf.asyncCarDelete(model)
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension WOWBuyCarController: buyCarDelegate {
    func goProductDetail(_ productId: Int?) {
        if let productId = productId {
            let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
            vc.hideNavigationBar = true
            vc.productId = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WOWBuyCarController: orderCarDelegate {
    func toProductDetail(_ productId: Int?) {
        if let productId = productId {
            let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
            vc.hideNavigationBar = true
            vc.productId = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


