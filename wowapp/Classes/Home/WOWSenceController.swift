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
        tableView.register(UINib.nibName(String(WOWSenceImageCell.self)), forCellReuseIdentifier:String(WOWSenceImageCell))
        tableView.register(UINib.nibName(String(WOWCommentCell.self)), forCellReuseIdentifier:String(WOWCommentCell))
        tableView.register(UINib.nibName(String(describing: WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
        tableView.register(UINib.nibName(String(WOWSenceLikeCell.self)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.mj_header = self.mj_header
        WOWSenceHelper.senceController = self
        configTableFooterView()
    }
    
    fileprivate func configData(){
        totalPriceLabel.text = sceneModel?.totalPrice?.priceFormat()
        favoriteButton.isSelected = (sceneModel?.userLike ?? "fasle") == "true"
    }
    

    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func configTableFooterView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.w - 0.5)/2,height: (self.view.w - 0.5)/2)
        layout.headerReferenceSize = CGSize(width: MGScreenWidth,height: 70);  //设置head大小
        layout.minimumInteritemSpacing = 0.5;
        layout.minimumLineSpacing = 0.5;
        layout.scrollDirection = .vertical
        footerCollectionView = UICollectionView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: 0), collectionViewLayout: layout)
        footerCollectionView.backgroundColor = DefaultBackColor
        WOWBorderColor(footerCollectionView)
        footerCollectionView.register(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"WOWCollectionHeaderCell")
        footerCollectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:String(describing: WOWImageCell))
        footerCollectionView.delegate = self
        footerCollectionView.dataSource = self
        tableView.tableFooterView = footerCollectionView
        footerCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context:nil)
    }
 
 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let height = self.footerCollectionView.collectionViewLayout.collectionViewContentSize.height
        guard height != footerCollectionView.size.height else{
            return
        }
        footerCollectionView.size = CGSize(width: MGScreenWidth, height: height)
        tableView.tableFooterView = footerCollectionView
    }
    
//MARK:Actions
    
    @IBAction func carClick(_ sender: UIButton) {
        let products = sceneModel?.products
        let alert = UIAlertController(title:"温馨提示", message:"确定添加\(products?.count ?? 0)件商品进购物车", preferredStyle: .alert)
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        let sure   = UIAlertAction(title: "确定", style: .default) { (action) in
            if let arr = products{
                if WOWUserManager.loginStatus { //登录了
                    self.saveNetCar(arr)
                }else{ //未登录
//                    self.saveRealm(arr)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)
    }
    
    //同步到云端购物车
    fileprivate func saveNetCar(_ arr:[WOWProductModel]){
        let uid = WOWUserManager.userID
        var cars = [AnyObject]()
        var param:[String:AnyObject] = ["uid":uid as AnyObject]
        if arr.count != 0 {
//            for obj in arr {
//                let dict = ["skuid":obj.skuID ?? "","count":"1","productid":String(obj.productId) ?? ""]
//                cars.append(dict)
//            }
            param["cart"] = cars as AnyObject?
            let string = JSONStringify(param)
            WOWNetManager.sharedManager.requestWithTarget(.api_CartList(cart:string), successClosure: { [weak self](result) in
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
    
//    private func saveRealm(arr:[WOWProductModel]){
//        for item in arr {
//            let buyCarModel = WOWBuyCarModel()
//            buyCarModel.productID       = item.productId ?? ""
//            buyCarModel.skuID           = item.skuID ?? ""
//            buyCarModel.skuProductPrice = item.price ?? ""
//            buyCarModel.skuProductName = item.productName ?? ""
//            buyCarModel.skuName         = "  " //FIXME:这个地方缺少一个规格
//            buyCarModel.skuProductImageUrl  = item.productImage ?? ""
//            
//            let exitSkus = WOWRealm.objects(WOWBuyCarModel).filter("skuID = '\(buyCarModel.skuID)'")
//            if let exitModel = exitSkus.first { //之前存在 那就更新数量
//                try! WOWRealm.write({ 
//                    exitModel.skuProductCount += 1
//                })
//            }else{//之前不存在
//                try! WOWRealm.write({
//                    WOWRealm.add(buyCarModel)
//                })
//            }
//        }
//        WOWBuyCarMananger.updateBadge()
//        WOWHud.showMsg("添加购物车成功")
//    }

    @IBAction func share(_ sender: UIButton) {
        //FIXME:暂时分享出去公司的官网
        WOWShareManager.share(sceneModel?.name, shareText: sceneModel?.desc, url: WOWCompanyUrl, shareImage:WOWSenceHelper.shareImage ?? UIImage(named: "me_logo")!)
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        let uid         = WOWUserManager.userID
        let thingid     = self.sceneID ?? ""
        let type        = "2" //1为商品 2 为场景
        let is_delete   = favoriteButton.isSelected ? "1":"0"
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Favotite(product_id:"", uid: uid, type: type, is_delete:is_delete, scene_id:thingid), successClosure: { [weak self](result) in
//            let json = JSON(result)
//            DLog(json)
//            if let strongSelf = self{
//                strongSelf.favoriteButton.selected = !strongSelf.favoriteButton.selected
//            }
//        }, failClosure: { (errorMsg) in
//                
//        })
    }
    
    
    
//MARK:Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_SenceDetail(sceneid:sceneID ?? "",uid:uid), successClosure: { [weak self](result) in
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
    func subAlertItemClick(_ productID:Int) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.productId = productID
        vc.hideNavigationBar = true
        WOWSenceHelper.senceController.navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWSenceController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return WOWSenceHelper.sectionsNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WOWSenceHelper.rowsNumberInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return WOWSenceHelper.cellForRow(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WOWSenceHelper.heightForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForHeaderInSection(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WOWSenceHelper.heightForFooterInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForFooterInSection(tableView, section: section)
    }
}


extension WOWSenceController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sceneModel?.recommendProducts?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWImageCell", for: indexPath) as! WOWImageCell
        let  model = sceneModel?.recommendProducts?[(indexPath as NSIndexPath).row]
//        cell.pictureImageView.kf_setImageWithURL(NSURL(string:model?.productImg ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        cell.pictureImageView.set_webimage_url(model?.productImg )

        cell.backgroundColor = SeprateColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let  model = sceneModel?.recommendProducts?[(indexPath as NSIndexPath).row]
        let  pid = model?.productId ?? 0
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.productId = pid
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var returnView:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWCollectionHeaderCell", for: indexPath) as! WOWReuseSectionView
            view.titleLabel.text = "猜你喜欢"
            returnView = view
        }
        if kind == UICollectionElementKindSectionFooter{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWCollectionFooterCell", for: indexPath) as!  WOWReuseSectionView
            view.titleLabel.text = ""
            returnView = view
        }
        return returnView
    }
}


