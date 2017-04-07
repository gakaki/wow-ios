//
//  WOWNewEnjoyController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import Koloda

class WOWNewEnjoyController: WOWBaseViewController {
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var rightSpace: NSLayoutConstraint!
    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    
    weak var delegate:WOWChideControllerDelegate?
    var fineWroksArr = [WOWFineWroksModel]()
    var categoryId = 0
    var indexRows = 0

    lazy var guideView:WOWNewGuideView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWNewGuideView.self), owner: self, options: nil)?.last as! WOWNewGuideView
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        let space = (MGScreenWidth - 190)/3
        rightSpace.constant = space
        leftSpace.constant = space
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = 1.0
        kolodaView.reloadData()
        request()
        // Do any additional setup after loading the view.
    }
    /**
     添加通知
     */
    fileprivate func addObserver(){

        NotificationCenter.default.addObserver(self, selector:#selector(refreshRequest), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshRequest), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)

    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        params = ["categoryId": categoryId   ,"type": 1 ,"startRows":indexRows,"pageSize":20]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                let r = JSON(result)
                
                let array   =  Mapper<WOWFineWroksModel>().mapArray(JSONObject: r["list"].arrayObject ) ?? [WOWFineWroksModel]()
                strongSelf.fineWroksArr = strongSelf.fineWroksArr + array
                strongSelf.kolodaView.reloadData()
                if strongSelf.fineWroksArr.count > 0 {
                    strongSelf.emptyView.isHidden = true
                }else {
                    strongSelf.emptyView.isHidden = false
                }
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.emptyView.isHidden = false
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }
        
        
    }
    
    func requestLike(type: Int, works worksId: Int) {

        WOWNetManager.sharedManager.requestWithTarget(.api_LikeWorks(worksId: worksId, type: type), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let _ = self {
               
            }

        }) { (errorMsg) in
            WOWHud.dismiss()
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.latest_picture_page)
        if !UserDefaults.standard.bool(forKey: "FirstTime_New") {
            UserDefaults.standard.set(true, forKey: "FirstTime_New")
            UserDefaults.standard.synchronize()
            /**  第一次进入，此处把第一次进入时要进入的控制器作为根视图控制器  */
            
            let window = UIApplication.shared.windows.last
            
            window?.addSubview(guideView)
            window?.bringSubview(toFront: guideView)
            
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
         kolodaView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        kolodaView.isHidden = true
    }
    // MARK: IBActions
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func refreshButton() {
        MobClick.e(.refresh_clicks_latest_picture_page)
        if let del = delegate {
            
            del.updateTabsRequsetData()
            
        }
        refreshRequest()

    }
    
    func refreshRequest() {
        indexRows = 0
        fineWroksArr = [WOWFineWroksModel]()
        kolodaView.resetCurrentCardIndex()
        request()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
// MARK: KolodaViewDelegate

extension WOWNewEnjoyController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        emptyView.isHidden = false
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let model = fineWroksArr[index]
        VCRedirect.bingWorksDetails(worksId: model.id ?? 0)
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
    
        if direction == .left {
            leftBtn.isHighlighted = true
        }else {
            leftBtn.isHighlighted = false
            
        }
        if direction == .right {
            rightBtn.isHighlighted = true
        }else {
            rightBtn.isHighlighted = false
            
        }
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        if direction == .left {
            leftBtn.isHighlighted = false
        }
        if direction == .right {
            rightBtn.isHighlighted = false
        }
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaDidResetCard(_ koloda: KolodaView) {
        
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
    }
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        guard WOWUserManager.loginStatus == true else{
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        let model = fineWroksArr[index]
        if direction == .left {
            MobClick.e(.dislike_clicks_latest_picture_page)
            requestLike(type: 0, works: model.id ?? 0)
        }
        if direction == .right {
            MobClick.e(.like_clicks_latest_picture_page)
            requestLike(type: 1, works: model.id ?? 0)
        }
        
        if fineWroksArr.count - index == 5 {
            indexRows = fineWroksArr.last?.id ?? 0
            request()
        }
    }
}

// MARK: KolodaViewDataSource

extension WOWNewEnjoyController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return fineWroksArr.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        var imgStr = ""
        if self.fineWroksArr.count > index {
          imgStr = self.fineWroksArr[index].pic ?? ""
        }
        return WOWCustomKoloda(frame: CGRect(x: 0, y: 0, w: MGScreenWidth - 36, h: MGScreenWidth - 20), imgStr)
    }
    
 
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}
