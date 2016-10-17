
import UIKit

protocol WOWHotStyleDelegate:class {
    // 刷新住列表数据
    func reloadTableViewData()
    
}


class WOWContentTopicController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var vo_products             = [WOWProductModel]()
    //param
    var topic_id: Int           = 1
    var vo_topic:WOWModelVoTopic?
    weak var  delegate :WOWHotStyleDelegate?
    fileprivate var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
    fileprivate(set) var numberSections = 0

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
        let view = Bundle.main.loadNibNamed(String(describing: WOWTopicNavigationItem.self), owner: self, options: nil)?.last as! WOWTopicNavigationItem
        view.thumbButton.addTarget(self, action: #selector(dgClick), for: .touchDown)
        view.shareButton.addTarget(self, action: #selector(zdClick), for: .touchUpInside)
        view.buyCarBUttion.addTarget(self, action: #selector(sjClick), for: .touchUpInside)
        return view
    }()
    // 刷新顶部数据
    func reloadNagationItemThumbButton(_ isFavorite: Bool, thumbNum: Int)  {
        nagationItem.thumbButton.isSelected = isFavorite
        nagationItem.numLabel.text = thumbNum.toString
    }
    //MARK:Actions

    func dgClick(_ sender: UIButton) -> Void {
        
        WOWClickLikeAction.requestLikeProject(topicId: topic_id,view: nagationItem,btn: sender) { [weak self](isFavorite) in

            if let strongSelf = self{
                
                // strongSelf.request()
                
                // 接口那边通过 请求这个页面的接口计算有多少人查看，如果此时调用这个接口拉新数据的话，会多一次请求，会造成一下两次的情况产生 ，所以前端处理 自增减1
                if isFavorite == true {
                    strongSelf.vo_topic!.likeQty = strongSelf.vo_topic!.likeQty! + 1
                }else{
                    strongSelf.vo_topic!.likeQty = strongSelf.vo_topic!.likeQty! - 1
                }
                
                strongSelf.reloadNagationItemThumbButton(isFavorite ?? false, thumbNum: strongSelf.vo_topic!.likeQty ?? 0)
//                strongSelf.delegate?.reloadTableViewData()
                 NotificationCenter.postNotificationNameOnMainThread(WOWUpdateProjectThumbNotificationKey, object: nil)
            }

        }
        
    }
    //分享
    func zdClick() -> Void {

        let shareUrl = WOWShareUrl + "/topic/\(topic_id )"
        WOWShareManager.share(vo_topic?.topicMainTitle, shareText: vo_topic?.topicDesc, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)

        
    }
    //去购物车
    func sjClick() -> Void {
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController.self)) as! WOWBuyCarController
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
    fileprivate func configData(){
        configBarItem()

        //如果相关商品有数据显示。如果没有数据则不显示
        if vo_products.count > 0 {
            //详情页共分为7组数据
            numberSections = 3
        }else {
            numberSections = 2
        }
    }
    
    
    fileprivate func configBarItem(){
        
        if WOWUserManager.userCarCount <= 0 {
            nagationItem.buyCarBUttion.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            nagationItem.buyCarBUttion.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            nagationItem.buyCarBUttion.badgeString = "99+"
        }

        makeRightNavigationItem(nagationItem)
    }
    fileprivate func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(buyCarCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<vo_products.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = vo_products[a]
            
            
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
        
            
        }
        self.tableView.reloadData()
    }

    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topics(topicId:topic_id), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                DLog(result)
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWModelVoTopic>().map( JSONObject:r.object )
                let imgView = UIImageView()
                imgView.kf.setImage(
                    with: URL(string:strongSelf.vo_topic!.topicImg ?? "" )!,
                    placeholder: nil,
                    options: nil,
                    progressBlock: { (arg1, arg2) in
                        
                        
                    },
                    completionHandler: { [weak self](image, error, cacheType, imageUrl) in
                        if let strongSelf = self{
                            strongSelf.shareProductImage = image
                        }
                    }
                )

                strongSelf.reloadNagationItemThumbButton(strongSelf.vo_topic!.favorite ?? false, thumbNum: strongSelf.vo_topic!.likeQty ?? 0)

              

                strongSelf.requestAboutProduct()
            }
            
        }){ (errorMsg) in
            print(errorMsg)
        }
        
        
    }
    
    func requestAboutProduct() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topic_Products(topicId:topic_id), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(JSONObject:r["productList"].arrayObject) ?? [WOWProductModel]()
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
//    func requestLikeProject(topicId: Int,isFavorite:LikeAction){
//        //用户喜欢某个单品
//     
//            WOWHud.showLoadingSV()
//            
//            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeProject(topicId: topicId), successClosure: {[weak self] (result) in
//                if let strongSelf = self{
//                   
//                    let favorite = JSON(result)["favorite"].bool ?? false
//
//                    isFavorite(isFavorite: favorite)
//
//                }
//            }) { (errorMsg) in
//                
//                return false
//        
//            }
//        
//    }

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
        tableView.register(UINib.nibName(String(describing: WOWContentTopicTopCell.self)), forCellReuseIdentifier:String(describing: WOWContentTopicTopCell.self))
        tableView.register(UINib.nibName(String(describing: WOWProductDetailCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailCell.self))
               //相关商品
        tableView.register(UINib.nibName(String(describing: WOWProductDetailAboutCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailAboutCell.self))
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return vo_topic?.imageSerial?.records?.count ?? 0
        default:
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (0,_): //
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWContentTopicTopCell.self), for: indexPath) as! WOWContentTopicTopCell
            cell.showData(vo_topic)
            returnCell = cell
        case (1,_): //产品描述
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductDetailCell.self), for: indexPath) as! WOWProductDetailCell
            if let array = vo_topic?.imageSerial?.records {
                let model = array[(indexPath as NSIndexPath).row]
                cell.showData(model)
                cell.productImg.tag = (indexPath as NSIndexPath).row
                cell.productImg.addTapGesture(action: {[weak self] (tap) in
                    if let strongSelf = self {
                        strongSelf.lookBigImg((tap.view?.tag)!)
                    }
                    
                    })
            }
            
            returnCell = cell

        case (2,_)://相关商品
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWProductDetailAboutCell", for: indexPath) as! WOWProductDetailAboutCell
            cell.dataArr = vo_products
            cell.delegate = self
            returnCell = cell
        default:
            break
        }
        return returnCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 15
        default:
            return 0.01
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
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
    
    func lookBigImg(_ beginPage:Int)  {
        DispatchQueue.main.async {
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
    func photoBrowerWillDisplay(_ beginPage: Int){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func photoBrowserWillEndDisplay(_ endPage: Int){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension WOWContentTopicController: WOWProductDetailAboutCellDelegate {
        @objc func selectCollectionIndex(_ productId: Int) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = productId
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
