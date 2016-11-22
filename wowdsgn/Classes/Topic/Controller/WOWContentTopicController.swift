
import UIKit
import IQKeyboardManagerSwift

protocol WOWHotStyleDelegate:class {
    // 刷新住列表数据
    func reloadTableViewData()
    
}


class WOWContentTopicController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pressButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputConstraint: NSLayoutConstraint!
    
    var vo_products             = [WOWProductModel]()
    //param
    var topic_id: Int           = 1
    var vo_topic:WOWContentTopicModel?
    var topicComment: WOWTopicCommentModel?         //评论model
    var imgUrlArr = [String]()  //存放图片url的数组
    let maxLength = 140         //输入评论最大字数限制
    let minLength = 3           //最小长度限制
    var isHaveTag = 0           //是否有标签，如果没有则不显示
    var isHaveComment = 0       //是否有评论，如果没有则不显示
    var isHaveAbout = 0         //是否有相关商品，如果没有则不显示
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true

    }
    deinit {
        removeObservers()
    }
 
    
     //MARK:    - lazy
    lazy var nagationItem:WOWTopicNavigationItem = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWTopicNavigationItem.self), owner: self, options: nil)?.last as! WOWTopicNavigationItem
        view.thumbButton.addTarget(self, action: #selector(dzClick), for: .touchDown)
        view.shareButton.addTarget(self, action: #selector(fxClick), for: .touchUpInside)
        view.buyCarBUttion.addTarget(self, action: #selector(bcClick), for: .touchUpInside)
        return view
    }()
  
    //评论
    lazy var conmmentView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        return v
    }()
    //相关商品
    lazy var aboutView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        return v
    }()
    //更多评论
    lazy var moreCommentView:WOWMoreCommentView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWMoreCommentView.self), owner: self, options: nil)?.last as! WOWMoreCommentView
        v.moreButton.addTarget(self, action: #selector(moreCommentClick), for: .touchUpInside)
        return v
    }()
    // 刷新顶部数据
    func reloadNagationItemThumbButton(_ isFavorite: Bool, thumbNum: Int)  {
        nagationItem.thumbButton.isSelected = isFavorite
        nagationItem.numLabel.text = thumbNum.toString
    }
    //MARK:Actions

    func dzClick(_ sender: UIButton) -> Void {
        
        WOWClickLikeAction.requestLikeProject(topicId: topic_id,view: nagationItem,btn: sender) { [weak self](isFavorite) in

            if let strongSelf = self{
            
                // 接口那边通过 请求这个页面的接口计算有多少人查看，如果此时调用这个接口拉新数据的话，会多一次请求，会造成一下两次的情况产生 ，所以前端处理 自增减1
                if isFavorite == true {
                    strongSelf.vo_topic!.likeQty = (strongSelf.vo_topic!.likeQty ?? 0)  + 1
                }else{
                    strongSelf.vo_topic!.likeQty = (strongSelf.vo_topic!.likeQty ?? 0) - 1
                }
                
                strongSelf.reloadNagationItemThumbButton(isFavorite ?? false, thumbNum: strongSelf.vo_topic!.likeQty ?? 0)
                
                strongSelf.delegate?.reloadTableViewData()
//                
                 NotificationCenter.postNotificationNameOnMainThread(WOWUpdateProjectThumbNotificationKey, object: nil)
            }

        }
        
    }
    //分享
    func fxClick() -> Void {

        let shareUrl = WOWShareUrl + "/topic/\(topic_id )"
        WOWShareManager.share(vo_topic?.topicName, shareText: vo_topic?.topicDesc, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)

        
    }
    //去购物车
    func bcClick() -> Void {
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
        configTextView()
    }

    //初始化数据，商品banner
    fileprivate func configData(){
        configBarItem()
        imgUrlArr = [String]()
        for  aa:WOWImages in vo_topic?.images ?? [WOWImages](){
            
            if let imgStr = aa.url{
                if !imgStr.isEmpty {
                    imgUrlArr.append(imgStr)

                }
                
            }
        }

        numberSections = 2 + isHaveTag + isHaveComment + isHaveAbout
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
    
    
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {

        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            vo_products.ergodicArrayWithProductModel(dic: send_obj)
            self.tableView.reloadData()
        }

      
    }

    fileprivate func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(buyCarCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topics(topicId:topic_id), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                DLog(result)
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWContentTopicModel>().map( JSONObject:r.object )
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
                //如果有标签的话就显示，没有的话就显示
                if strongSelf.vo_topic?.tag?.count > 0 {
                    strongSelf.isHaveTag = 1
                }else {
                    strongSelf.isHaveTag = 0
                }
                //如果专题不允许评论就不显示评论区域
                if strongSelf.vo_topic?.allowComment ?? false {
                    strongSelf.bottomViewConstraint.constant = 0
                    strongSelf.bottomView.isHidden = false
                    
                }else {
                    strongSelf.bottomViewConstraint.constant = -50
                    strongSelf.bottomView.isHidden = true
                    
                }
                strongSelf.view.layoutIfNeeded()

                strongSelf.reloadNagationItemThumbButton(strongSelf.vo_topic!.favorite ?? false, thumbNum: strongSelf.vo_topic!.likeQty ?? 0)
              
                strongSelf.requestAboutProduct()
            }
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
        }
        
        
    }
    
    func requestAboutProduct() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topic_Products(topicId:topic_id), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(JSONObject:r["productList"].arrayObject) ?? [WOWProductModel]()
                //如果产品数组有数据则表示有相关产品
                if strongSelf.vo_products.count > 0 {
                    strongSelf.isHaveAbout = 1
                }else {
                    strongSelf.isHaveAbout = 0
                }
                
                strongSelf.requestCommentList()
                
            }
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
            
        }
    }
    
    ///获取评论列表
    func requestCommentList() {
        WOWNetManager.sharedManager.requestWithTarget(.api_TopicCommentList(pageSize: 10, currentPage: 1, topicId: topic_id), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let r = JSON(result)
                strongSelf.topicComment = Mapper<WOWTopicCommentModel>().map( JSONObject:r.object )
                if strongSelf.topicComment?.comments?.count > 0 {
                    strongSelf.isHaveComment = 1
                }else {
                    strongSelf.isHaveComment = 0
                }
                //初始化详情页数据
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                
                strongSelf.endRefresh()

            }
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
            
        }
    
    }
    //发表评论
    func requestSendComment(_ content: String) {
        WOWNetManager.sharedManager.requestWithTarget(.api_SubmitTopicComment(topicId: topic_id, content: content), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.endEditing()
                strongSelf.requestCommentList()
            }
            
        }){[weak self] (errorMsg) in
            
        }
    }
//    func requestLikeProject(topicId: Int,isFavorite:LikeAction){
//        //用户喜欢某个单品
//     
//            WOWHud.showLoadingSV()
//            
//            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_LikeProject(topicId: topicId), successClosure: {[weak self] (result, code) in
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
        tableView.register(UINib.nibName(String(describing: WOWContentDetailCell.self)), forCellReuseIdentifier:String(describing: WOWContentDetailCell.self))
        tableView.register(UINib.nibName(String(describing: WOWTopicTagCell.self)), forCellReuseIdentifier:String(describing: WOWTopicTagCell.self))
        //评论
        tableView.register(UINib.nibName(String(describing: WOWCommentCell.self)), forCellReuseIdentifier:String(describing: WOWCommentCell.self))
        
        //相关商品
        tableView.register(UINib.nibName(String(describing: WOWProductDetailAboutCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailAboutCell.self))
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return vo_topic?.images?.count ?? 0
        case 1 + isHaveTag + isHaveComment://评论最多显示3条
            if isHaveComment == 1 {
                if let count = topicComment?.total {
                    return count > 3 ? 3 : count
                }
                return 0
            }else {
                return 1
            }

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
            cell.delegeta = self
            returnCell = cell
        case (1,_): //产品描述
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWContentDetailCell.self), for: indexPath) as! WOWContentDetailCell
            if let array = vo_topic?.images {
                let model = array[(indexPath as NSIndexPath).row]
                cell.showData(model)
                for imgStr in imgUrlArr.enumerated() {
                    if imgStr.element == model.url {
                        cell.productImg.tag = imgStr.offset
                        cell.productImg.addTapGesture(action: {[weak self] (tap) in
                            if let strongSelf = self {
                                strongSelf.lookBigImg((tap.view?.tag)!)
                            }
                            
                            })
                    }
                }
                
            }
            
            returnCell = cell
        case (1 + isHaveTag,_)://标签
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWTopicTagCell", for: indexPath) as! WOWTopicTagCell
            cell.showData(vo_topic?.tag)
            cell.delegate = self
            returnCell = cell
        case (1 + isHaveTag + isHaveComment,_)://评论
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWCommentCell", for: indexPath) as! WOWCommentCell
            cell.modelData = topicComment?.comments?[indexPath.row]
            cell.showData(topicComment?.comments?[indexPath.row])
            returnCell = cell
        case (1 + isHaveTag + isHaveComment + isHaveAbout,_)://相关商品
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
        case 1 + isHaveTag + isHaveComment://评论
            if isHaveComment == 1 {
                return 39
            }else {
                return 0.01
            }
        case 1 + isHaveTag + isHaveComment + isHaveAbout: //如果相关商品有数据显示，如果没有就不显示
            if vo_products.count > 0 {
                return 39
            }else {
                return 0.01
            }
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1 + isHaveTag + isHaveComment:     //更多评论。当评论数大于三条时才显示
            if topicComment?.total > 3 {
                return 55
            }else {
                return 0.01
            }
        default:
            return 0.01
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1 + isHaveTag + isHaveComment:
            if isHaveComment == 1 {
                conmmentView.labelText.text = String(format: "评论（%i）", topicComment?.total ?? 0)
                return conmmentView
            }else {
                return nil
            }
        case 1 + isHaveTag + isHaveComment + isHaveAbout:     //如果相关商品有数据显示，如果没有就不显示
            if vo_products.count > 0 {
                aboutView.labelText.text = "相关商品"
                return aboutView
            }else {
                return nil
            }
            
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1 + isHaveTag + isHaveComment: //更多评论
            if topicComment?.total > 3 {
                return moreCommentView
            }else {
                let view = UIView()
                view.backgroundColor = UIColor.clear
                return view
            }

        default:
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }
    
    }
    
}

extension WOWContentTopicController: PhotoBrowserDelegate{
    func setPhoto() -> [PhotoModel] {
        var photos: [PhotoModel] = []
        imgUrlArr = [String]()
        for  aa:WOWImages in vo_topic?.images ?? [WOWImages](){
            
            if let imgStr = aa.url{
                if !imgStr.isEmpty {
                    imgUrlArr.append(imgStr)
                    let photoModel = PhotoModel(imageUrlString: imgStr, sourceImageView: nil)
                    photos.append(photoModel)
                }
                
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

extension WOWContentTopicController: WOWProductDetailAboutCellDelegate, WOWTopicTagCellDelegate, WOWContentTopicTopCellDelegate {
        @objc func selectCollectionIndex(_ productId: Int) {
        toVCProduct(productId)
    }
    
    func columnGoTopic(_ columnId: Int?, topicTitle title: String?) {
       
        toVCArticleListVC(columnId ?? 0, title: title ?? "",isOpenTag: false,isPageView: true)
    }
    
    func tagGoTopic(_ tagId: Int?, tagTitle title: String?) {
        toVCArticleListVC(tagId ?? 0, title: title ?? "",isOpenTag: true,isPageView: true)
    }
    
}

//评论专区
extension WOWContentTopicController: UITextViewDelegate{
    fileprivate func endEditing(){
        self.inputTextView.resignFirstResponder()
        self.inputTextView.text = ""
        self.inputConstraint.constant = 30
        self.view.layoutIfNeeded()
    }
    fileprivate func configTextView() {
        inputTextView.delegate = self
    }
  
//        commentView.delegates.textViewDidChange = { [weak self](growingTextView: NextGrowingTextView) in
//            // Do something
//            if let strongSelf = self {
//                
//                
//                let language = growingTextView.textInputMode?.primaryLanguage
//                //        FLOG("language:\(language)")
//                if let lang = language {
//                    if lang == "zh-Hans" ||  lang == "zh-Hant" || lang == "ja-JP"{ //如果是中文简体,或者繁体输入,或者是日文这种带默认带高亮的输入法
//                        let selectedRange = growingTextView.textView.markedTextRange
//                        var position : UITextPosition?
//                        if let range = selectedRange {
//                            position = growingTextView.textView.position(from: range.start, offset: 0)
//                        }
//                        //系统默认中文输入法会导致英文高亮部分进入输入统计，对输入完成的时候进行字数统计
//                        if position == nil {
//                            //                    FLOG("没有高亮，输入完毕")
//                            strongSelf.limitTextLength(growingTextView)
//                           
//                        }
//                    }else{//非中文输入法
//                        strongSelf.limitTextLength(growingTextView)
//                       
//                    }
//                }
//
//            }
//            
//        }
//    }
//    fileprivate func limitTextLength(_ textView: NextGrowingTextView){
//        
//        let toBeString = textView.text as NSString
//        print("tobeString：\(toBeString)")
////        if (toBeString.length <= minLength) {
////            WOWHud.showMsg("请您输入更多内容")
////        }
//        if (toBeString.length > maxLength) {
//            WOWHud.showMsg("输入文字不超过140字")
//            textView.text = toBeString.substring(to: maxLength)
//        }
//    }
//
    @IBAction func pressClick(_ sender: UIButton) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }

        if inputTextView.text.isEmpty {
            WOWHud.showMsg("您的评论为空")
            return
        }
        if inputTextView.text.length < 3 {
            WOWHud.showMsg("请您输入更多内容")
            return
        }
        if inputTextView.text.length > 140 {
            WOWHud.showMsg("评论的最大字数为140字，请您删减")
            return
        }
        requestSendComment(inputTextView.text)
    }
    //更多评论
    func moreCommentClick() {
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWCommentController.self)) as! WOWCommentController
        navigationController?.pushViewController(vc, animated: true)
      

    }

    func keyBoardWillShow(_ note:Notification){
        let userInfo  = (note as NSNotification).userInfo as [AnyHashable: Any]!
        let  keyBoardBounds = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {[weak self]() in
            if let strongSelf = self {
                strongSelf.bottomViewConstraint.constant = deltaY
                strongSelf.view.layoutIfNeeded()
            }
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    func keyBoardWillHide(_ note:Notification){
        let userInfo  = (note as NSNotification).userInfo as [AnyHashable: Any]!
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = { [weak self]() in
            if let strongSelf = self {
                //如果专题不允许评论就不显示评论区域
                if strongSelf.vo_topic?.allowComment ?? false {
                    strongSelf.bottomViewConstraint.constant = 0
                    strongSelf.bottomView.isHidden = false
                    
                }else {
                    strongSelf.bottomViewConstraint.constant = -50
                    strongSelf.bottomView.isHidden = true
                    
                }
                strongSelf.view.layoutIfNeeded()
            }
            
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    var COMMENTS_LIMIT:Int{
        get {
            return 140
        }
    }
    //delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        backgroundView.isHidden = false
        pressButton.isEnabled = true
        pressButton.setBackgroundColor(UIColor.init(hexString: "ffd444")!, forState: .normal)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        backgroundView.isHidden = true
        //如果有评论发布键可点击，没有评论发布键不可点击
        if textView.text.isEmpty {
            pressButton.isEnabled = false
            pressButton.setBackgroundColor(UIColor.init(hexString: "eaeaea")!, forState: .normal)
        }else {
            pressButton.isEnabled = true
            pressButton.setBackgroundColor(UIColor.init(hexString: "ffd444")!, forState: .normal)
        }

    }
    //    //中文和其他字符的判断方式不一样
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = inputTextView.frame.size.width
        inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 120 {
            inputConstraint.constant = 120
        }else {
            inputConstraint.constant = newSize.height
            
        }
        self.view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
//            send()
            return false
        }
//        let ret = textView.text.characters.count + text.characters.count - range.length <= COMMENTS_LIMIT
//        if ret == false{
//            WOWHud.showMsg("您输入的字符超过限制")
//            return false
//        }
        return true
    }

    
}

