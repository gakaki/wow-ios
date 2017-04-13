//
//  WOWBuyCarController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBuyCarController: WOWBaseViewController {
    let cellNormalID = String(describing: WOWBuyCarNormalCell.self)
    let cellID = String(describing: WOWOrderCell.self)
    let pageSize           = 10 //分页每页拉取数据
    var bottomListCount    = 0 // 底部数组个数
    var bottomCellLine     = 0 // 底部cell number
    var bottomListArray    = [WOWProductModel](){//底部列表数组 ,如果有底部瀑布流的话
        didSet{
            
            bottomListCount = bottomListArray.count
            bottomCellLine  = bottomListCount.getParityCellNumber()
        }
    }

    //购物车中全部商品数组
    var dataArr = [WOWCarProductModel](){
        didSet{
            /**
             *  如果购物车内没有商品底部view就隐藏
             */
            if dataArr.count == 0 {
                bottomView.isHidden = true
                bottomHeight.constant = 0
            }else{
                bottomView.isHidden = false
                bottomHeight.constant = 50
            }
        }
    }
    //有效商品的数组
    var validArr = [WOWCarProductModel](){
        didSet{
            /**
             *  如果购物车内没有有效商品，全选按钮设为不可点击状态
             */
            if validArr.isEmpty {
                allButton.isEnabled = false
            }else{
                allButton.isEnabled = true
            }
           
        }
    }

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
//                totalPrice = result
                totalPriceLabel.text = result
            

            
        }
    }
    
    @IBOutlet weak var allButton: UIButton!             //全选按钮
    @IBOutlet weak var tableView: UITableView!          //购物车列表
    @IBOutlet weak var endButton: UIButton!             //去结算按钮
    @IBOutlet weak var totalPriceLabel: UILabel!        //商品总价
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!    //底部view高度

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        request()
        MobClick.e(.Shoppingcart)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.Cart_Detail_Page)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestBuyCarProduct()

    }
    deinit {
        removeObservers()
    }


    //促销信息
    lazy var emptyHeaderView:WOWBuyCarEmpty = {
        let view = Bundle.main.loadNibNamed("WOWBuyCarEmpty", owner: self, options: nil)?.last as! WOWBuyCarEmpty
        return view
    }()
    lazy var headerView:WOWBuyCarHeaderView = {
        let view = Bundle.main.loadNibNamed("WOWBuyCarHeaderView", owner: self, options: nil)?.last as! WOWBuyCarHeaderView
        return view
    }()
//MARK:Private Method
    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    fileprivate func removeObservers(){
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
        
    }
    //MARK notidication method
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        
        if  let send_obj =  sender.object as? [String:AnyObject] {
            bottomListArray.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.reloadData()
                }
                
            })
            
        }
        
    }
    func loginSuccess() {
        request()
        requestBuyCarProduct()
    }
    
    fileprivate func allbuttonIsSelect() {
        //如果选中的数组数量跟购物车内有效的商品数量相同全选按钮置为选中状态
        if selectedArr.count > 0 {
            if selectedArr.count == validArr.count {
                allButton.isSelected = true
            }else{
                allButton.isSelected = false
            }
        }
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
        tableView.estimatedRowHeight = 162
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(String(describing: WOWBuyCarNormalCell.self)), forCellReuseIdentifier:cellNormalID)
        tableView.register(UINib.nibName(String(describing: WOWOrderCell.self)), forCellReuseIdentifier:cellID)
        self.tableView.register(UINib.nibName("HomeBottomCell"), forCellReuseIdentifier: "HomeBottomCell")
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor
        self.tableView.mj_header = self.mj_header

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
            WOWHud.showMsg("您还没有选中商品")
            return
        }
        
        for product in selectedArr {
            if product.productStatus == -1 {
                let str = String(format:"您购买的商品\"%@\"已失效",product.productName ?? "")

                WOWHud.showWarnMsg(str)
                return
            }
            if product.productStatus == 2 {
                let str = String(format:"您购买的商品\"%@\"已下架",product.productName ?? "")
                WOWHud.showWarnMsg(str)
                return
            }
            if product.productStatus == 1 && product.productStock == 0 {
                let str = String(format:"您购买的商品\"%@\"已售罄",product.productName ?? "")
                WOWHud.showWarnMsg(str)
                return
            }
            if product.limitQty > 0 {
                if product.productQty > product.limitQty {
                    let str = String(format:"%@每人限购%i件，请修改",product.productName ?? "", product.limitQty ?? 1)
                    WOWHud.showWarnMsg(str)
                    return
                }
            }
            
        }
        MobClick.e(.Buy_Clicks)
         //结算
            let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWEditOrderController") as!WOWEditOrderController
            sv.entrance = editOrderEntrance.carEntrance
            navigationController?.pushViewController(sv, animated: true)
        
    }
    
    
//MARK:全选按钮点击
    @IBAction func allButtonClick(_ sender: UIButton) {
        MobClick.e(.Select_All_Clicks)
        //判断全选按钮的状态，如果是全部选中的状态，点击按钮取消全部选中，如果未选中状态，点击按钮则要全部选中
        if sender.isSelected {
            asynCartUnSelect(validArr)
          
        }else{
            asyncCartSelect(validArr)
        }
        
    }
    
    

    
//MARK Network 购物车
    
    /**
     个人购物车的数据
     */
    override func request() {
        super.request()
        requestBottom()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        requestBuyCarProduct()
    }
    
    fileprivate func requestBuyCarProduct() {
        //1.直接拉取服务器端购物车数据
        WOWNetManager.sharedManager.requestWithTarget(.api_CartGet, successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                
                //TalkingData 购物车显示
                let shoppingCart = TDShoppingCart.create()
                
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
                         1 已上架 2已下架 -1已失效
                         
                         如果已下架，isSelect = false
                         */
                        if product.productStatus == 2 || product.productStatus == -1{
                            product.isSelected = false
                        }
                    }
                    strongSelf.updateCarCountBadge()
                    
                    
                    strongSelf.validArr = [WOWCarProductModel]()
                    strongSelf.selectedArr = [WOWCarProductModel]()
                    //判断当前数组有多少默认选中的加入选中的数组
                    for product in strongSelf.dataArr {
                        
                        if product.productStatus == 1 && product.productStock > 0{
                            strongSelf.validArr.append(product)
                            if product.isSelected ?? false {
                                strongSelf.selectedArr.append(product)
                            }
                            
                            let id    = String(describing:(product.productId ?? 0))
                            let price = Int32( product.sellPrice ?? 0 ) * 100
                            let name  = product.productName ?? ""
                            let amount = Int32( product.productQty ?? 0 )
                            shoppingCart?.addItem(withCategory: "", itemId: id, name: name, unitPrice: price, amount: amount)
                            
                        }
                        
                    }
                    //如果选中的数组数量跟购物车内有效的商品数量相同全选按钮置为选中状态
                    strongSelf.allbuttonIsSelect()
                }else {
                    strongSelf.dataArr = []
                    strongSelf.bottomView.isHidden = true
                }
                strongSelf.endRefresh()
                
                strongSelf.tableView.reloadData()
                
                
                TalkingDataAppCpa.onViewShoppingCart(shoppingCart)
                
            }
            }) {[weak self] (errorMsg) in
                if let strongSelf = self{
                    strongSelf.endRefresh()
                    WOWHud.showMsgNoNetWrok(message: errorMsg)
                }
        }
    }

    /**
     3.删除购物车数据
     - parameter items:
     */
    func asyncCarDelete(_ model: WOWCarProductModel){
        var shoppingCartId = [Int]()
        shoppingCartId.append(model.shoppingCartId ?? 0)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_CartRemove(shoppingCartId:shoppingCartId), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                MobClick.e(.Delectproduct_Clicks)
                strongSelf.dataArr.removeObject(model)
                if strongSelf.validArr.contains(model) {
                    
                    strongSelf.validArr.removeObject(model)

                }
                WOWUserManager.userCarCount -= model.productQty ?? 1
                //更新购物车数量信息
                strongSelf.updateCarCountBadge()
                //判断一下如果删除的商品是已选中商品。那么从selectedArr中也要删除这个元素
                
                if model.isSelected ?? false{
                    strongSelf.selectedArr.removeObject(model)
                }
                strongSelf.tableView.reloadData()
                strongSelf.allbuttonIsSelect()
            }
        }) { (errorMsg) in
                WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    }
    
    
    /**
     4.更改购物车商品数量
     
     - parameter items:
     */
    fileprivate func asyncUpdateCount(_ shoppingCartId: Int, productQty: Int, indexPath: IndexPath){

        WOWNetManager.sharedManager.requestWithTarget(.api_CartModify(shoppingCartId:shoppingCartId, productQty: productQty), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                MobClick.e(.Selectnumber_Clicks)
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
                strongSelf.tableView.reloadData()
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
        WOWNetManager.sharedManager.requestWithTarget(.api_CartSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result, code) in
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
                strongSelf.allbuttonIsSelect()
            }
           

            }) { (errorMsg) in
                WOWHud.showMsgNoNetWrok(message: errorMsg)
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
        WOWNetManager.sharedManager.requestWithTarget(.api_CartUnSelect(shoppingCartIds: shoppingCartIdArray), successClosure: {[weak self] (result, code) in
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
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    
    }
    //为你推荐
    fileprivate func requestBottom()  {
        
        WOWNetManager.sharedManager.requestWithTarget(.api_CartBottomList(pageSize: currentPageSize, currentPage: pageIndex), successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["products"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.bottomListArray = []
                        
                        
                    }
                    if bannerList.count < strongSelf.pageSize {// 如果拿到的数据，小于分页，则说明，无下一页
                        
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                        
                    }
                    
                    strongSelf.bottomListArray.append(contentsOf: bannerList)
                    
                }else {
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.bottomListArray = []
                    }
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
                strongSelf.tableView.reloadData()
                WOWHud.dismiss()
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
    }

}


extension WOWBuyCarController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count + bottomCellLine
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < dataArr.count {
            let model = dataArr[(indexPath as NSIndexPath).section]
            //productStatus = 1 已上架，productStatus = 2 已下架
            if model.productStatus == 1 && model.productStock > 0{
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
        }else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: "HomeBottomCell", for: indexPath) as! HomeBottomCell
            
            cell.indexPath = indexPath
            cell.pageTitle = self.title ?? ""
//            cell.moduleId = model.moduleId ?? 0
            let OneCellNumber = ((indexPath as NSIndexPath).section + 0 - dataArr.count) * 2
            let TwoCellNumber = (((indexPath as NSIndexPath).section + 1 - dataArr.count) * 2) - 1
            if bottomListCount.isOdd && (indexPath as NSIndexPath).section + 1 ==   bottomListCount.getParityCellNumber() {//  满足为奇数 第二个item 隐藏
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:bottomListArray)
                
            }else{
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:bottomListArray)
                
            }
            cell.delegate = self
            cell.selectionStyle   = .none
            
            return cell

        }
        
        
    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self](action, indexPath) in
                if let strongSelf = self {
                    
                    strongSelf.alertView(strongSelf.dataArr[(indexPath as NSIndexPath).section])
                }
            }
            return [delete]
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section < dataArr.count {
            return true
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section < dataArr.count {
            return 15
        }else {
            if section == dataArr.count {
                if dataArr.count == 0 {
                    return 325
                }else {
                    return 65
                }

            }else {
                return 0.01
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == dataArr.count {
            if dataArr.count == 0 {
                return emptyHeaderView
            }else {
                return headerView
            }
        }else {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }
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
    
    // 配置cell的UI
    func cellUIConfig(one: NSInteger, two: NSInteger ,isHiddenTwoItem: Bool, cell:HomeBottomCell,dataSourceArray:[WOWProductModel])  {
        let  modelOne = dataSourceArray[one]
        if isHiddenTwoItem == false {
            
            cell.showDataOne(modelOne)
            cell.twoLb.isHidden = false
            
        }else{
            
            let  modelTwo = dataSourceArray[two]
            cell.showDataOne(modelOne)
            cell.showDataTwo(modelTwo)
            cell.twoLb.isHidden = true
        }
        
        cell.oneBtn.tag = one
        cell.twoBtn.tag = two
        
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

extension WOWBuyCarController: buyCarDelegate, HomeBottomDelegate {
    func goProductDetail(_ productId: Int?) {
        VCRedirect.toVCProduct(productId)
    
    }
    func goToProductDetailVC(_ productId: Int?){
        VCRedirect.toVCProduct(productId)
        
    }
  
}

extension WOWBuyCarController: orderCarDelegate {
    func toProductDetail(_ productId: Int?) {
        
        VCRedirect.toVCProduct(productId)
    }
}



