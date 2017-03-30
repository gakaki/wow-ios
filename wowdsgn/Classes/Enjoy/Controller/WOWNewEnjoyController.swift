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

        // Do any additional setup after loading the view.
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
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func refreshButton() {
        
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
    }
    
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
}

// MARK: KolodaViewDataSource

extension WOWNewEnjoyController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return WOWCustomKoloda(frame: CGRect(x: 0, y: 0, w: MGScreenWidth - 36, h: MGScreenWidth - 20), "https://img.wowdsgn.com/product/images/1b4a96a6-c620-46af-8e1b-021a4cac71d0.jpg")
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}
