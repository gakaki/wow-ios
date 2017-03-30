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
    var fineWroksArr = [WOWFineWroksModel]()
    var categoryId = 0
    var indexRows = 0
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<5 {
            array.append(UIImage(named: "guide0")!)
        }
        
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
   
        request()
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
                
//                strongSelf.tableView.reloadData()
                strongSelf.kolodaView.dataSource = self
                strongSelf.kolodaView.delegate = self
                strongSelf.kolodaView.alphaValueSemiTransparent = 1.0
                print(r)
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
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
    // MARK: IBActions
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
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
//        for i in 1...4 {
//            dataSource.append(UIImage(named: "guide0")!)
//        }
//        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        print(finishPercentage)
        print(direction)
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
