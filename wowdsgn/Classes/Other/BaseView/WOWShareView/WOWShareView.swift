//
//  WOWShareView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/23.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum WOWShareType:String{
    case friends
    case wechat
    case needPhone
    case needCustomer
}

typealias ShareViewAction = (_ shareType:WOWShareType) -> Void

class WOWShareBackView:UIView{
    var shareActionBack : ShareViewAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backClear:UIView! = {
        let v = UIView(frame:CGRect(x: 0, y: self.h, width: self.w,height: self.h))
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    lazy var customerView:WOWCustomer = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWCustomer.self), owner: self, options: nil)?.last as! WOWCustomer
        v.viewPhone.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(WOWShareType.needPhone)
                }
                strongSelf.dismiss()
            }
        }
        
        v.viewMessage.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(WOWShareType.needCustomer)
                }
                strongSelf.dismiss()
            }
        }
        return v
    }()
    lazy var shareView:WOWShareView = {
       let v = Bundle.main.loadNibNamed(String(describing: WOWShareView.self), owner: self, options: nil)?.last as! WOWShareView
        v.friendView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(WOWShareType.friends)
                }
                strongSelf.dismiss()
            }
        }
        
        v.wechatView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                if let action = strongSelf.shareActionBack {
                    action(WOWShareType.wechat)
                }
                strongSelf.dismiss()
            }
        }
        return v
    }()
    
    fileprivate func setUP(){
        self.backgroundColor = MaskColor
        self.alpha = 0
        self.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.dismiss()
            }
        }
    }

    
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
    
    lazy var sharePhotoView:WOWSharePhotoView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWSharePhotoView.self), owner: self, options: nil)?.last as! WOWSharePhotoView


     
        return v
    }()
    func showNeedHelp() {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(customerView)
        
        customerView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    func show() {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(shareView)

        shareView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }

        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: { [unowned self] in

            self.alpha = 1
            self.backClear.y = 0
        }) 
    }

    func showPhotoImg(_ m: WOWWorksDetailsModel) {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(shareView)
        backClear.addSubview(sharePhotoView)
        
        sharePhotoView.imgPhoto.set_webimage_url(m.pic ?? "")
        sharePhotoView.lbMyName.text = "By " +  (m.nickName ?? "")
        sharePhotoView.lbDes.text = m.des ?? ""
        sharePhotoView.lbCurrentTime.text = m.pubTime ?? ""
        shareView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }
        
        self.layoutIfNeeded()
        
        sharePhotoView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.centerY.equalTo((MGScreenHeight - 128) / 2)
                
                make.centerX.equalTo(strongSelf.backClear.centerX)
                
                make.left.equalTo(strongSelf.backClear).offset(30)
                make.right.equalTo(strongSelf.backClear).offset(-30)
       
                
            }
        }
       
        sharePhotoView.layoutIfNeeded()
        self.layoutIfNeeded()
        let heightImg =  m.picHeight * (MGScreenWidth - 80 ) / MGScreenWidth

        sharePhotoView.heightImgConstraint.constant = heightImg
        
        sharePhotoView.layoutIfNeeded()
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    func dismiss() {
        UIView.animate(withDuration: 0.3,animations: { [unowned self] in
            self.alpha = 0
            self.backClear.y = MGScreenHeight + 10;
        }, completion: {[weak self] (ret) in
            if let strongSelf = self  {
                strongSelf.backClear.removeFromSuperview()
                strongSelf.sharePhotoView.removeFromSuperview()
                strongSelf.removeFromSuperview()
            }
        })
    }
}


class WOWShareView: UIView {
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var wechatView: UIView!
//    @IBOutlet weak var weiboView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        friendView.isHidden = !WowShare.is_wx_installed()
        wechatView.isHidden = !WowShare.is_wx_installed()
    }
    
}
