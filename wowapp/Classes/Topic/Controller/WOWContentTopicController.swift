//
//  WOWContentTopicController.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWContentTopicController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vo_products             = [WOWProductModel]()
    //param
    var topic_id: Int           = 1
    var vo_topic:WOWModelVoTopic?
    
    private var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
    private(set) var numberSections = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        request()
        // Do any additional setup after loading the view.
    }
    deinit {
        removeObservers()
    }
    
     //MARK:    - lazy
    lazy var nagationItem:WOWTopicNavigationItem = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWTopicNavigationItem), owner: self, options: nil).last as! WOWTopicNavigationItem
        view.thumbButton.addTarget(self, action: #selector(dgClick), forControlEvents: .TouchUpInside)
        view.shareButton.addTarget(self, action: #selector(zdClick), forControlEvents: .TouchUpInside)
        view.buyCarBUttion.addTarget(self, action: #selector(sjClick), forControlEvents: .TouchUpInside)
        return view
    }()
    
    //MARK:Actions

    func dgClick() -> Void {
        print("dianzan")
        
        
    }
    func zdClick() -> Void {
        let shareUrl = WOWShareUrl + "/item/\(topic_id ?? 0)"
        WOWShareManager.share(vo_topic?.topicMainTitle, shareText: vo_topic?.topicDesc, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)

        
    }
    func sjClick() -> Void {
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
        configBarItem()
    }

    //初始化数据，商品banner
    private func configData(){
        //如果相关商品有数据显示。如果没有数据则不显示
        if vo_products.count > 0 {
            //详情页共分为7组数据
            numberSections = 3
        }else {
            numberSections = 2
        }
    }
    
    
    private func configBarItem(){
        
        if WOWUserManager.userCarCount <= 0 {
            nagationItem.buyCarBUttion.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            nagationItem.buyCarBUttion.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            nagationItem.buyCarBUttion.badgeString = "99+"
        }

        makeRightNavigationItem(nagationItem)
    }
    private func addObservers(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(buyCarCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
    }
    
    private func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    
    /**
     购物车数量显示
     */
    func buyCarCount()  {
        if WOWUserManager.userCarCount <= 0 {
            nagationItem.buyCarBUttion.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            nagationItem.buyCarBUttion.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            nagationItem.buyCarBUttion.badgeString = "99+"
        }
        
        
    }
    //MARK: - NET
    override func request(){
        
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Topics(topicId:topic_id), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWModelVoTopic>().map( r.object )
                strongSelf.requestAboutProduct()
            }
            
        }){ (errorMsg) in
            print(errorMsg)
        }
        
        
    }
    
    func requestAboutProduct() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Topic_Products(topicId:topic_id), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(r["productList"].arrayObject) ?? [WOWProductModel]()
                //初始化详情页数据
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
            print(errorMsg)
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension WOWContentTopicController: UITableViewDelegate, UITableViewDataSource {
    func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        //显示价格的cell
        tableView.registerNib(UINib.nibName(String(WOWContentTopicTopCell)), forCellReuseIdentifier:String(WOWContentTopicTopCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailCell)), forCellReuseIdentifier:String(WOWProductDetailCell))
               //相关商品
        tableView.registerNib(UINib.nibName(String(WOWProductDetailAboutCell)), forCellReuseIdentifier:String(WOWProductDetailAboutCell))
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return vo_topic?.imageSerial?.records?.count ?? 0
        default:
            return 1
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch (indexPath.section,indexPath.row) {
        case (0,_): //
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWContentTopicTopCell), forIndexPath: indexPath) as! WOWContentTopicTopCell
            cell.showData(vo_topic)
            returnCell = cell
        case (1,_): //产品描述
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailCell), forIndexPath: indexPath) as! WOWProductDetailCell
            if let array = vo_topic?.imageSerial?.records {
                let model = array[indexPath.row]
                cell.showData(model)
                cell.productImg.tag = indexPath.row
                cell.productImg.addTapGesture(action: {[weak self] (tap) in
                    if let strongSelf = self {
                        strongSelf.lookBigImg((tap.view?.tag)!)
                    }
                    
                    })
            }
            
            returnCell = cell

        case (2,_)://相关商品
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailAboutCell", forIndexPath: indexPath) as! WOWProductDetailAboutCell
            cell.dataArr = vo_products
            cell.delegate = self
            returnCell = cell
        default:
            break
        }
        return returnCell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2: //如果相关商品有数据显示，如果没有就不显示
            if vo_products.count > 0 {
                return 30
            }else {
                return 0.01
            }
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 15
        default:
            return 0.01
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:     //如果相关商品有数据显示，如果没有就不显示
            if vo_products.count > 0 {
                return "相关商品"
            }else {
                return nil
            }
            
        default:
            return nil
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
}

extension WOWContentTopicController: PhotoBrowserDelegate{
    func setPhoto() -> [PhotoModel] {
        var photos: [PhotoModel] = []
        
        for  aa:WOWProductPicTextModel in vo_topic?.imageSerial?.records ?? [WOWProductPicTextModel](){
            
            if let imgStr = aa.image{
                
                let photoModel = PhotoModel(imageUrlString: imgStr, sourceImageView: nil)
                photos.append(photoModel)
            }
        }
        
        
        return photos
    }
    
    func lookBigImg(beginPage:Int)  {
        dispatch_async(dispatch_get_main_queue()) {
            let photoBrowser = PhotoBrowser(photoModels:self.setPhoto()) {[weak self] (extraBtn) in
                if let sSelf = self {
                    let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (sSelf.view.zj_height - 80)*0.5, width: sSelf.view.zj_width, height: 80.0))
                    sSelf.view.addSubview(hud)
                }
                
            }
            // 指定代理
            photoBrowser.delegate = self
            photoBrowser.show(inVc: self, beginPage: beginPage)
            
        }
        
    }
    func photoBrowerWillDisplay(beginPage: Int){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func photoBrowserWillEndDisplay(endPage: Int){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension WOWContentTopicController: WOWProductDetailAboutCellDelegate {
        @objc func selectCollectionIndex(productId: Int) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = productId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
