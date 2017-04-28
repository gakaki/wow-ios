//
//  WOWPickerView.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
//MARK:*****************************背景视图******************************************

class WOWPickerBackView: UIView {
    //MARK:Lazy
    lazy var pickerView:WOWPickerView = {
        let v = Bundle.loadResourceName(String(describing: WOWPickerView.self)) as! WOWPickerView
        v.cancelButton.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        backgroundColor = MaskColor
        self.alpha = 0
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dismissButton:UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
        b.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        return b
    }()
    //MARK:Private Method
    fileprivate func setUP(){
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.equalTo(strongSelf).offset(0)
                make.height.equalTo(250)
                make.bottom.equalTo(strongSelf).offset(250)
            }
        }
        insertSubview(dismissButton, belowSubview: pickerView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf).offset(0)
                make.bottom.equalTo(strongSelf.pickerView.snp.top).offset(0)
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    
    //MARK:Actions
    func show() {
        
        pickerView.snp.updateConstraints { [unowned self](make) in
            make.bottom.equalTo(self).offset(0)
        }
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.layoutIfNeeded()
            }
            
        })
    }
    
    func hideView(){
        pickerView.snp.updateConstraints { [unowned self] (make) in
            make.bottom.equalTo(self).offset(250)
        }
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.layoutIfNeeded()
                
            }
            
            }, completion: {[weak self] (ret) in
                if let strongSelf = self {
                    strongSelf.removeFromSuperview()
                    
                }
        })
    }
    
    
}

class WOWPickerView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sureButton: UIButton!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
