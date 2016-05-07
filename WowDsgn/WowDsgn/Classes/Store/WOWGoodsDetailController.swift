//
//  WOWGoodsDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit




class WOWGoodsDetailController: WOWBaseViewController {
    var productID:String?
    
    var cycleView:CyclePictureView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    var productModel:WOWProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = .None
        configTableView()
        configHeaderView()
    }
    
//MARK:Private Method
    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sureButton(_:)), name: WOWGoodsSureBuyNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginSuccess), name: WOWLoginSuccessNotificationKey, object:nil)
    }
    
    func loginSuccess() {
        request()
    }
    
    func sureButton(nf:NSNotification)  {
        let object = nf.object as? WOWBuyCarModel
        if let model = object {
           resolveBuyModel(model)
        }
        backView.hideBuyView()
    }

    
    private func resolveBuyModel(model:WOWBuyCarModel){
        //放进购物车管理类，进行选中
        WOWBuyCarMananger.sharedBuyCar.chooseProducts.append(model.skuID)
        
        if WOWUserManager.loginStatus { //登录
            saveNetBuyCar(model)
        }else{
            //存入本地数据库 先判断是否存在
            let skus = WOWRealm.objects(WOWBuyCarModel).filter("skuID = '\(model.skuID)'")
            if let m = skus.first{
                let count = m.skuProductCount
                model.skuProductCount += count
                try! WOWRealm.write({
                    WOWRealm.add(model, update: true)
                })
                WOWHud.showMsg("添加购物车成功")
            }else{
                try! WOWRealm.write({
                    WOWRealm.add(model, update:true)
                })
                WOWHud.showMsg("添加购物车成功")
            }
        }
    }
    
    
    private func saveNetBuyCar(model:WOWBuyCarModel){
        let uid = WOWUserManager.userID
        let carItems = [["skuid":model.skuID,"count":"\(model.skuProductCount)","productid":model.productID,"skuname":model.skuName]]
        let param = ["uid":uid,"cart":carItems,"tag":"0"]
        let string = JSONStringify(param)
        WOWNetManager.sharedManager.requestWithTarget(.Api_CarEdit(cart:string), successClosure: {[weak self] (result) in
            if let _ = self{
                WOWHud.showMsg("添加购物车成功")
            }
        }) { (errorMsg) in
            WOWHud.showMsg("添加购物车失败")
        }
    }
    
    
    private func configTableView(){
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        tableView.registerNib(UINib.nibName(String(WOWGoodsTypeCell)), forCellReuseIdentifier:String(WOWGoodsTypeCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsDetailCell)), forCellReuseIdentifier:String(WOWGoodsDetailCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsParamCell)), forCellReuseIdentifier:String(WOWGoodsParamCell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:String(WOWCommentCell))
        tableView.registerNib(UINib.nibName(String(WOWDesignerCell)), forCellReuseIdentifier:String(WOWDesignerCell))  
    }
    
    private func configHeaderView(){
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth), imageURLArray: nil)
        cycleView.placeholderImage = UIImage(named: "placeholder_banner")
        tableView.tableHeaderView = cycleView
    }
    
    private func configData(){
        priceLabel.text = productModel?.price?.priceFormat() ?? ""
        cycleView.imageURLArray = [productModel?.productImage ?? ""]
        favoriteButton.selected = (productModel?.user_isLike ?? "false") == "true"
    }
    
//MARK:Actions
    
    @IBAction func carEntranceClick(sender: UIButton) {
        let buyCar = UIStoryboard.initialViewController("BuyCar")
        self.presentViewController(buyCar, animated: true, completion: nil)
    }

//MARK:Private Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductDetail(product_id: productID ?? "",uid:uid), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.productModel = Mapper<WOWProductModel>().map(result)
                
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func likeButtonClick(sender: UIButton) {
        if !WOWUserManager.loginStatus {
            goLogin()
        }else{
            let uid         = WOWUserManager.userID
            let thingid     = self.productID ?? ""
            let type        = "1" //1为商品 2 为场景
            let is_delete   = favoriteButton.selected ? "1":"0"
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Favotite(product_id: thingid, uid: uid, type: type, is_delete:is_delete, scene_id:""), successClosure: { [weak self](result) in
                let json = JSON(result)
                DLog(json)
                if let strongSelf = self{
                    strongSelf.favoriteButton.selected = !strongSelf.favoriteButton.selected
                }
            }, failClosure: { (errorMsg) in
                    
            })
        }
    }
    
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }

    
    @IBAction func shareButtonClick(sender: UIButton) {
        let shareUrl = "http://www.wowdsgn.com/\(productModel?.skuID ?? "").html"
        WOWShareManager.share(productModel?.productName, shareText: productModel?.productDes, url:shareUrl)
    }
    
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight))
        return v
    }()

//MARK:选择规格
    @IBAction func buyButtonClick(sender: UIButton) {
        WOWBuyCarMananger.sharedBuyCar.producModel = self.productModel
        WOWBuyCarMananger.sharedBuyCar.skuName     = self.productModel?.skus?.first?.skuTitle
        WOWBuyCarMananger.sharedBuyCar.buyCount    = 1
        WOWBuyCarMananger.sharedBuyCar.skuID       = self.productModel?.skus?.first?.skuID ?? ""
        WOWBuyCarMananger.sharedBuyCar.skuPrice = productModel?.price ?? ""
        WOWBuyCarMananger.sharedBuyCar.skuDefaultSelect = 0
        view.addSubview(backView)
        view.bringSubviewToFront(backView)
        backView.show()
    }
}

extension WOWGoodsDetailController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //系列
            return 1
        case 1: //图文
            if let pics = productModel?.pics_compose{
                return pics.count
            }
            return 0
        case 2: //设计师
            if let _ = productModel?.designer_name{
                return 1
            }
            return 0
        case 3: //参数
            if let att = productModel?.attributes {
                return att.count
            }
            return 0
        case 4: //喜欢
            return 0
        case 5: //评论
            if let commentList = productModel?.comments {
                return commentList.count > 5 ? 5 : commentList.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsTypeCell), forIndexPath: indexPath) as! WOWGoodsTypeCell
            cell.headImageView.addTarget(self, action: #selector(brandHeadClick), forControlEvents:.TouchUpInside)
            cell.showData(productModel)
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsDetailCell), forIndexPath: indexPath) as! WOWGoodsDetailCell
            if let pics = productModel?.pics_compose{
                let model = pics[indexPath.row]
                cell.showData(model)
            }
            returnCell = cell
        case 2: //设计师
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWDesignerCell), forIndexPath:indexPath) as! WOWDesignerCell
            cell.showData(productModel)
            returnCell = cell
        case 3: //参数
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsParamCell), forIndexPath: indexPath) as! WOWGoodsParamCell
            if let att = productModel?.attributes {
                cell.showData(att[indexPath.row])
            }
            returnCell = cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWSenceLikeCell),forIndexPath: indexPath) as! WOWSenceLikeCell
            cell.rightTitleLabel.text = "\(productModel?.likesCount ?? 0)人喜欢"
            cell.rightBackView.addAction({ [weak self] in
                if let strongSelf = self{
                    let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
                    strongSelf.navigationController?.pushViewController(likeVC, animated: true)
                }
            })
            returnCell = cell
        case 5: //评论
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWCommentCell),forIndexPath: indexPath)as!WOWCommentCell
            cell.hideHeadImage()
            if let model = productModel?.comments![indexPath.row]{
                cell.commentLabel.text = model.comment
                cell.dateLabel.text    = model.created_at
                cell.nameLabel.text    = model.user_nick
            }
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    func brandHeadClick() {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = productModel?.brandID
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func moreLikeButtonClick(){
        let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
        navigationController?.pushViewController(likeVC, animated: true)
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return productModel?.designer_name == nil ? 0.01 : 36
        case 3:
            return 36
        case 5: //评论
            if let arr = productModel?.comments {
                return arr.count == 0 ? 0.01 : 36
            }
            return 0.01
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 0.01
        case 1,3:
            return 20
        case 5: //评论
            return 44
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0,1:
            return nil
        case 2: //设计师
            return productModel?.designer_name == nil ? nil : WOWMenuTopView(leftTitle: "设计师", rightHiden: true, topLineHiden: true, bottomLineHiden: false)
        case 3://参数
            return WOWMenuTopView(leftTitle: "产品参数", rightHiden: true, topLineHiden: true, bottomLineHiden: false)
        case 5: //评论
            if let arr = productModel?.comments {
                if arr.count == 0 {
                    return nil
                }else{
                    let view =  WOWMenuTopView(leftTitle: "\(productModel?.comments_count ?? 0)条评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
                    goComment(view)
                    return view
                }
            }else{
                return nil
            }
        default:
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 5 {
            let footerView = WOWMenuTopView(leftTitle: "发表评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
            goComment(footerView)
            return footerView
        }
        return nil
    }
    
    private func goComment(commentView:UIView!){
        commentView.addAction{[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                vc.commentType = CommentType.Product
                vc.mainID = self?.productID!
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
}



