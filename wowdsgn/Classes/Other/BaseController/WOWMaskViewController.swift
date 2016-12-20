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
  
    var updateModel     : WOWUpdateVersionModel!
    
    var updateContent   = [String]()
    
    // 根据返回的内容的高度，来更新View的高度
    func updateHeight(height:CGFloat){
        updateView.snp.updateConstraints { (make) in
            make.height.equalTo(height + 150)
        }
    }
    
    // 代理方法， 点击取消，页面消失
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
    // 添加view控件
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
    lazy var updateView: WOWUpdateView = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateView.self)) as! WOWUpdateView
        
        view.delegate       = self
        view.updateModel    = self.updateModel
        
        return view
        
    }()
    
    lazy var bgView: UIView = {
        
        let t = UIView()
        // 点击蒙版取消页面操作，注释掉
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissAction))
//        t.addGestureRecognizer(tap)
        return t
        
    }()
  
    // 移除View
    func removeAllView(){
        
        bgView.removeFromSuperview()
        updateView.removeFromSuperview()
    }
    //
    func dismissAction()  {
        
        self.removeAllView()
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension UIViewController {
    // presentViewController  使当前控制器 颜色透明
    func presentToViewController(viewControllerToPresent:UIViewController,completion: (() -> Swift.Void)? = nil) {
        
        self.definesPresentationContext = true
        viewControllerToPresent.view.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(viewControllerToPresent, animated: false, completion: completion)
        
    }
    
    
}
