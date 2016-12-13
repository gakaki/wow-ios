//
//  SecondViewController.swift
//  AlterViewController
//
//  Created by 陈旭 on 2016/12/7.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
import SnapKit
class WOWMaskViewController: UIViewController,UpdateHeightDelegate{
    
    var updateContent = [String]()
    
    func updateHeight(height:CGFloat){
        updateView.snp.updateConstraints { (make) in
            make.height.equalTo(height + 150)
        }
    }
    func actionBlcok(){
        self.dismissAction()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyleView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupStyleView()  {
        
        let window = UIApplication.shared.keyWindow

        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bgView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        window?.addSubview(bgView)
        window?.addSubview(updateView)
        updateView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self {
                make.width.equalTo(263)
                make.height.equalTo(398)
                make.center.equalTo(strongSelf.bgView.center)
            }
        }
    }
    lazy var updateView: UIView = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateView.self)) as! WOWUpdateView
       
        view.delegate       = self
        view.updateContent  = self.updateContent
        return view
        
    }()
    
    lazy var bgView: UIView = {
        
        let t = UIView()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(WOWMaskViewController.dismissAction))
        t.addGestureRecognizer(tap)
        return t
        
    }()
    deinit {
        
        bgView.removeFromSuperview()
        updateView.removeFromSuperview()
        
    }
    func dismissAction()  {
        
        self.dismiss(animated: false, completion: nil)
        
    }
}

extension UIViewController {
    
    func presentToViewController(viewControllerToPresent:UIViewController,completion: (() -> Swift.Void)? = nil) {
        
        self.definesPresentationContext = true
        viewControllerToPresent.view.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(viewControllerToPresent, animated: false, completion: completion)
        
    }
    
    
}
