//
//  WOWSenceController.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSenceController: WOWBaseViewController {
    var footerCollectionView        : UICollectionView!
    @IBOutlet weak var tableView    : UITableView!
    var sceneID                     : String?
    var sceneModel                  : WOWSenceModel?
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    deinit{
        footerCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = "场景"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib.nibName(String(WOWSenceImageCell)), forCellReuseIdentifier:String(WOWSenceImageCell))
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:String(WOWCommentCell))
        tableView.registerNib(UINib.nibName(String(WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.mj_header = self.mj_header
        WOWSenceHelper.senceController = self
        configTableFooterView()
    }
    
    private func configData(){
        totalPriceLabel.text = sceneModel?.totalPrice?.priceFormat()
        favoriteButton.selected = (sceneModel?.userLike ?? "fasle") == "true"
    }
    

    @IBAction func backButtonClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func configTableFooterView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((self.view.w - 1)/2,(self.view.w - 1)/2)
        layout.headerReferenceSize = CGSizeMake(MGScreenWidth,70);  //设置head大小
        layout.minimumInteritemSpacing = 0.5;
        layout.minimumLineSpacing = 0.5;
        layout.scrollDirection = .Vertical
        footerCollectionView = UICollectionView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: 0), collectionViewLayout: layout)
        footerCollectionView.backgroundColor = DefaultBackColor
        WOWBorderColor(footerCollectionView)
        footerCollectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"WOWCollectionHeaderCell")
        footerCollectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
        footerCollectionView.delegate = self
        footerCollectionView.dataSource = self
        tableView.tableFooterView = footerCollectionView
        footerCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
    }
 
 
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let height = self.footerCollectionView.collectionViewLayout.collectionViewContentSize().height
        guard height != footerCollectionView.size.height else{
            return
        }
        footerCollectionView.size = CGSizeMake(MGScreenWidth, height)
        tableView.tableFooterView = footerCollectionView
    }
    
//MARK:Actions
    
    @IBAction func carClick(sender: UIButton) {
        let products = sceneModel?.products
        let alert = UIAlertController(title:"温馨提示", message:"确定添加\(products?.count ?? 0)件商品进购物车", preferredStyle: .Alert)
        let cancel = UIAlertAction(title:"取消", style: .Cancel, handler: nil)
        let sure   = UIAlertAction(title: "确定", style: .Default) { (action) in
            if let arr = products{
                if WOWUserManager.loginStatus { //登录了
                    self.saveNetCar(arr)
                }else{ //未登录
                    self.saveRealm(arr)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //同步到云端购物车
    private func saveNetCar(arr:[WOWProductModel]){
        let uid = WOWUserManager.userID
        var cars = [AnyObject]()
        var param:[String:AnyObject] = ["uid":uid]
        if arr.count != 0 {
            for obj in arr {
                let dict = ["skuid":obj.skuID ?? "","count":"1","productid":obj.productID ?? ""]
                cars.append(dict)
            }
            param["cart"] = cars
            let string = JSONStringify(param)
            WOWNetManager.sharedManager.requestWithTarget(.Api_CarList(cart:string), successClosure: { [weak self](result) in
                if let _ = self{
                    let json = JSON(result)
                    DLog(json)
                    WOWHud.showMsg("添加购物车成功")
                    let count = json["productcount"].int ?? 0
                    WOWUserManager.userCarCount = count
                    WOWBuyCarMananger.updateBadge()
                }
                }, failClosure: { (errorMsg) in
                    WOWHud.showMsg("添加购物车失败")
            })
        }
    }
    
    private func saveRealm(arr:[WOWProductModel]){
        for item in arr {
            let buyCarModel = WOWBuyCarModel()
            buyCarModel.productID       = item.productID ?? ""
            buyCarModel.skuID           = item.skuID ?? ""
            buyCarModel.skuProductPrice = item.price ?? ""
            buyCarModel.skuProductName = item.productName ?? ""
            buyCarModel.skuName         = "  " //FIXME:这个地方缺少一个规格
            buyCarModel.skuProductImageUrl  = item.productImage ?? ""
            
            let exitSkus = WOWRealm.objects(WOWBuyCarModel).filter("skuID = '\(buyCarModel.skuID)'")
            if let exitModel = exitSkus.first { //之前存在 那就更新数量
                try! WOWRealm.write({ 
                    exitModel.skuProductCount += 1
                })
            }else{//之前不存在
                try! WOWRealm.write({
                    WOWRealm.add(buyCarModel)
                })
            }
        }
        WOWBuyCarMananger.updateBadge()
        WOWHud.showMsg("添加购物车成功")
    }
    
//    lazy var shareView:WOWShareBackView = {
//        let v = WOWShareBackView(frame:CGRectMake(0, 0, self.view.w, self.view.h))
//        return v
//    }()
    
    @IBAction func share(sender: UIButton) {
//        shareView.show()
        //FIXME:暂时分享出去公司的官网
        WOWShareManager.share(sceneModel?.name, shareText: sceneModel?.desc, url: WOWCompanyUrl, shareImage:WOWSenceHelper.shareImage ?? UIImage(named: "me_logo")!)
    }
    
    @IBAction func favorite(sender: UIButton) {
        let uid         = WOWUserManager.userID
        let thingid     = self.sceneID ?? ""
        let type        = "2" //1为商品 2 为场景
        let is_delete   = favoriteButton.selected ? "1":"0"
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Favotite(product_id:"", uid: uid, type: type, is_delete:is_delete, scene_id:thingid), successClosure: { [weak self](result) in
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                strongSelf.favoriteButton.selected = !strongSelf.favoriteButton.selected
            }
        }, failClosure: { (errorMsg) in
                
        })
    }
    
    
    
//MARK:Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_SenceDetail(sceneid:sceneID ?? "",uid:uid), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.sceneModel = Mapper<WOWSenceModel>().map(result)
                WOWSenceHelper.sceneModel = strongSelf.sceneModel
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                strongSelf.footerCollectionView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
}



//MARK: Delegate
extension WOWSenceController:WOWSubAlertDelegate{
    func subAlertItemClick(productID:String) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.productID = productID
        vc.hideNavigationBar = true
        WOWSenceHelper.senceController.navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWSenceController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return WOWSenceHelper.sectionsNumber()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WOWSenceHelper.rowsNumberInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return WOWSenceHelper.cellForRow(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WOWSenceHelper.heightForHeaderInSection(section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForHeaderInSection(tableView, section: section)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WOWSenceHelper.heightForFooterInSection(section)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForFooterInSection(tableView, section: section)
    }
}


extension WOWSenceController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sceneModel?.recommendProducts?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        let  model = sceneModel?.recommendProducts?[indexPath.row]
        cell.pictureImageView.kf_setImageWithURL(NSURL(string:model?.productImage ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        cell.backgroundColor = SeprateColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let  model = sceneModel?.recommendProducts?[indexPath.row]
        let  pid = model?.productID ?? ""
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.productID = pid
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var returnView:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWCollectionHeaderCell", forIndexPath: indexPath) as! WOWReuseSectionView
            view.titleLabel.text = "猜你喜欢"
            returnView = view
        }
        if kind == UICollectionElementKindSectionFooter{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWCollectionFooterCell", forIndexPath: indexPath) as!  WOWReuseSectionView
            view.titleLabel.text = ""
            returnView = view
        }
        return returnView
    }
}


