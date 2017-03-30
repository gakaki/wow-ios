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
    
    var fineWroksArr = [WOWFineWroksModel]()
    var categoryId = 0
    var indexRows = 6
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<5 {
            array.append(UIImage(named: "guide0")!)
        }
        
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space = (MGScreenWidth - 190)/3
        rightSpace.constant = space
        leftSpace.constant = space
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = 1.0
        kolodaView.reloadData()
//        request()
        // Do any additional setup after loading the view.
    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        params = ["categoryId": categoryId   ,"type": 1 ,"startRows":indexRows,"pageSize":10]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                let r = JSON(result)
                
                strongSelf.fineWroksArr          =  Mapper<WOWFineWroksModel>().mapArray(JSONObject: r["list"].arrayObject ) ?? [WOWFineWroksModel]()
        
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        
        
    }
    
    func requestLike(type: Int) {
        WOWHud.showLoadingSV()
        guard WOWUserManager.loginStatus == true else{
            WOWHud.dismiss()
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_LikeWorks(worksId: categoryId, type: type), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self {
                if type == 0 {
                    strongSelf.kolodaView?.swipe(.left)
                }else{
                    strongSelf.kolodaView?.swipe(.right)
                }
            }

        }) { (errorMsg) in
            
            
            WOWHud.dismiss()
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
    }
    lazy var emptyView:WOWNewEmptyView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWNewEmptyView.self), owner: self, options: nil)?.last as! WOWNewEmptyView
       
        return v
    }()
    // MARK: IBActions
    
    @IBAction func leftButtonTapped() {
        requestLike(type: 0)
    }
    
    @IBAction func rightButtonTapped() {
        requestLike(type: 1)
    }
    
    @IBAction func refreshButton() {
        kolodaView.resetCurrentCardIndex()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
// MARK: KolodaViewDelegate

extension WOWNewEnjoyController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = kolodaView.currentCardIndex
//        for _ in 1...4 {
//            dataSource.append(UIImage(named: "guide0")!)
//        }
//        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
        emptyView.frame = CGRect(x: 0, y: 0, w: MGScreenWidth - 36, h: 300)
        koloda.addSubview(emptyView)
//        kolodaView.resetCurrentCardIndex()
        
    }
    
//    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
//        return false
//    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {

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
        if index >= 3 {
            indexRows = 10
            kolodaView.reloadData()
        }
    }
}

// MARK: KolodaViewDataSource

extension WOWNewEnjoyController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return indexRows
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        var imgStr = ""
        if self.fineWroksArr.count > index {
          imgStr = self.fineWroksArr[index].pic ?? ""
        }
        imgStr = "https://img.wowdsgn.com/social/insta/K4UnIA_2dimension_750x750"
        return WOWCustomKoloda(frame: CGRect(x: 0, y: 0, w: MGScreenWidth - 36, h: MGScreenWidth - 20), imgStr)
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}
