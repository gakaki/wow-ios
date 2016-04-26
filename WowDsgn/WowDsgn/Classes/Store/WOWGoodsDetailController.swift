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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    var productModel:WOWProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        addObservers()
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    }
    
    func sureButton(nf:NSNotification)  {
        let object = nf.object as? WOWBuyCarModel
        if let model = object {
           resolveBuyModel(model)
        }
        backView.hideBuyView()
    }
    
    private func resolveBuyModel(model:WOWBuyCarModel){
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
            }else{
                try! WOWRealm.write({
                    WOWRealm.add(model, update:true)
                })
            }
        }
    }
    
    
    private func saveNetBuyCar(model:WOWBuyCarModel){
        let uid = WOWUserManager.userID
        let carItems = [["skuid":model.skuID,"count":"\(model.skuProductCount)","productid":model.productID,"skuname":model.skuName]]
        let param = ["uid":uid,"cart":carItems]
        let string = JSONStringify(param)
        DLog(string)
        WOWNetManager.sharedManager.requestWithTarget(.Api_CarEdit(cart:string), successClosure: {[weak self] (result) in
            if let _ = self{
                
            }
        }) { (errorMsg) in
                
        }
    }
    
    
    private func configTableView(){
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        tableView.registerNib(UINib.nibName(String(WOWGoodsTypeCell)), forCellReuseIdentifier:String(WOWGoodsTypeCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsDetailCell)), forCellReuseIdentifier:String(WOWGoodsDetailCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsParamCell)), forCellReuseIdentifier:String(WOWGoodsParamCell))
        tableView.registerNib(UINib.nibName(String(WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
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
        cycleView.imageURLArray = [productModel?.productImage ?? ""]
    }

//MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductDetail(product_id: productID ?? ""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
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
        DLog("收藏")
    }
    
    @IBAction func shareButtonClick(sender: UIButton) {
        //替换
        let shareText = "尖叫君....."
        //微信好友
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        UMSocialData.defaultData().extConfig.wechatSessionData.url = "www.baidu.com"
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatSessionData.title = "尖叫君"
        
        //朋友圈
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = "www.baidu.com"
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = "尖叫君"
        
        //微博
        UMSocialData.defaultData().extConfig.sinaData.shareText = shareText + "www.baidu.com"
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "me_logo")
        
        UMSocialSnsService.presentSnsIconSheetView(self, appKey:WOWUMKey, shareText:"", shareImage:nil, shareToSnsNames: [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina], delegate: self)
        
    }
    
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenHeight))
        return v
    }()

//MARK:选择规格
    @IBAction func buyButtonClick(sender: UIButton) {
        WOWBuyCarMananger.sharedBuyCar.producModel = self.productModel
        view.addSubview(backView)
        view.bringSubviewToFront(backView)
        backView.show()
    }
}


extension WOWGoodsDetailController:UMSocialUIDelegate{
    func isDirectShareInIconActionSheet() -> Bool {
        return true
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if response.responseCode == UMSResponseCodeSuccess {
            DLog("分享成功")
        }else{
            WOWHud.showMsg("分享失败")
        }
    }
    
}




extension WOWGoodsDetailController:WOWSubAlertDelegate{
    func subAlertItemClick() {
        let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
        sence.hideNavigationBar = true
        sence.senceEntrance = .FromGoods
        navigationController?.pushViewController(sence, animated: true)
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
            return 1
        case 5: //评论
            return 5
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
            cell.rightTitleLabel.text = "\(productModel?.favorites_count ?? 0)人喜欢"
            cell.rightBackView.addAction({ [weak self] in
                if let strongSelf = self{
                    let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
                    strongSelf.navigationController?.pushViewController(likeVC, animated: true)
                }
            })
            returnCell = cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWCommentCell),forIndexPath: indexPath)as!WOWCommentCell
            cell.hideHeadImage()
            //FIXME:测试数据
            cell.commentLabel.text = "我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君"
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    func brandHeadClick() {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
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
            return 36
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
            let view =  WOWMenuTopView(leftTitle: "\(productModel?.comments_count ?? 0)条评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
            goComment(view)
            return view
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



