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
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
//    deinit{
//        footerCollectionView.removeObserver(self, forKeyPath: "contentSize")
//    }
    
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
        WOWSenceHelper.senceController = self
    }

    @IBAction func backButtonClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    func configTableFooterView(){
        let space:CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((MGScreenWidth - space * 3)/2,(MGScreenWidth - space)/2)
        layout.headerReferenceSize = CGSizeMake(MGScreenWidth,50);  //设置head大小
        layout.footerReferenceSize = CGSizeMake(MGScreenWidth,50);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space)
        layout.scrollDirection = .Vertical
        footerCollectionView = UICollectionView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: 0), collectionViewLayout: layout)
        footerCollectionView.backgroundColor = UIColor.whiteColor()
        footerCollectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"WOWCollectionHeaderCell")
         footerCollectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier:"WOWCollectionFooterCell")
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
    }*/
    
//MARK:Actions
    
    @IBAction func carClick(sender: UIButton) {
        let products = sceneModel?.products
        let alert = UIAlertController(title:"温馨提示", message:"确定添加\(products?.count ?? 0)件商品进购物车", preferredStyle: .Alert)
        let cancel = UIAlertAction(title:"取消", style: .Cancel, handler: nil)
        let sure   = UIAlertAction(title: "确定", style: .Default) { (action) in
            if let arr = products{
                if WOWUserManager.loginStatus { //登录了
                    self.saveNetCar()
                }else{ //未登录
                    self.saveRealm(arr)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //FIXME:同步到云端购物车去
    private func saveNetCar(){
        
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
        WOWHud.showMsg("添加购物车成功")
    }
    
    @IBAction func share(sender: UIButton) {
        //FIXME:是分享出去公司的官网还是商品或者场景呢
        WOWShareManager.share(sceneModel?.name, shareText: sceneModel?.desc, url: sceneModel?.url)
    }
    
    @IBAction func favorite(sender: UIButton) {
        DLog("收藏")
    }
    
    
    
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_SenceDetail(sceneid:sceneID ?? ""), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.sceneModel = Mapper<WOWSenceModel>().map(result)
                WOWSenceHelper.sceneModel = strongSelf.sceneModel
                //FIXME:价钱要转字符串
                strongSelf.tableView.reloadData()
            }
        }) { (errorMsg) in
                
        }
    }
    
}



//MARK: Delegate
extension WOWSenceController:WOWSubAlertDelegate{
    func subAlertItemClick(productID:String) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
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

/*
extension WOWSenceController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        cell.pictureImageView.image = UIImage(named: "testBrand")
        WOWBorderColor(cell.pictureImageView)
        return cell
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
*/

