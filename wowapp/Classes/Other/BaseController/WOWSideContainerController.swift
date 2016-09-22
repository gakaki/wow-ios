//
//  WOWSideController.swift
//  SideController
//
//  Created by dcpSsss on 16/4/2.
//  Copyright © 2016年 dcpSsss. All rights reserved.
//

import UIKit

class WOWSideContainerController: UIViewController {
    var mainController:UIViewController!
    var sideController:UIViewController!
    var sideViewContainer = UIView()
    var mainViewContainer = UIView()
    var showing:Bool = false
    var showDuration:Double = 0.5
    
    convenience init(sideViewController:UIViewController!,mainViewController:UIViewController!){
        self.init()
        mainController = mainViewController
        sideController = sideViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configContent()
    }
    
    fileprivate func configContent(){
        self.view.addSubview(mainViewContainer)
        self.view.addSubview(sideViewContainer)
        sideViewContainer.frame = CGRect(x: -self.view.bounds.size.width, y: self.view.bounds.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        sideViewContainer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addChildViewController(sideController)
        sideController.view.frame = self.view.bounds
        sideController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        sideViewContainer.addSubview(sideController.view)
        sideViewContainer.isHidden = true
        
        mainViewContainer.frame = self.view.bounds
        mainViewContainer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addChildViewController(mainController)
        self.mainController.view.frame = self.view.bounds
        mainViewContainer.addSubview(mainController.view)
    }
    
    func showSide(){
        showing = true
        sideViewContainer.isHidden = false
        UIView.animate(withDuration: showDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: { () -> Void in
            var mainTranslateForm = self.mainViewContainer.layer.transform
            mainTranslateForm = CATransform3DTranslate(mainTranslateForm,UIScreen.main.bounds.size.width-80, 0, 0)
            self.mainViewContainer.layer.transform = mainTranslateForm
            
            var sideTranslateForm = self.sideViewContainer.layer.transform //值类型
            sideTranslateForm = CATransform3DTranslate(sideTranslateForm, self.view.bounds.size.width, 0, 0)
            self.sideViewContainer.layer.transform = sideTranslateForm
            }, completion: nil)
    }
    
    func hideSide(){
        showing = false
        UIView.animate(withDuration: showDuration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: { () -> Void in
            self.mainViewContainer.layer.transform = CATransform3DIdentity
            self.sideViewContainer.layer.transform = CATransform3DIdentity
        }) { (bool) -> Void in
            self.sideViewContainer.isHidden = true
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
