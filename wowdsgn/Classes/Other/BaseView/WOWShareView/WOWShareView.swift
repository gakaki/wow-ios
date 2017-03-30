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
        
//        v.weiboView.addTapGesture {[weak self](tap) in
//            if let strongSelf = self{
//                if let action = strongSelf.shareActionBack {
//                    action(shareType: WOWShareType.weibo)
//                }
//                strongSelf.dismiss()
//            }
//        }
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
        let nowDate = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateString = formatter.string(from: nowDate as Date)

        v.lbCurrentTime.text = dateString
        return v
    }()

    func show() {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(shareView)
//        backClear.addSubview(sharePhotoView)
        
        shareView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }

        self.layoutIfNeeded()
//        print("\(backClear.centerY)--\(shareView.centerY)--\(self.centerY)")
//        sharePhotoView.snp.makeConstraints {[weak self] (make) in
//            if let strongSelf = self{
//                make.centerY.equalTo((MGScreenHeight - 128) / 2)
//
//                make.centerX.equalTo(strongSelf.backClear.centerX)
//
//                make.left.equalTo(strongSelf.backClear).offset(30)
//                make.right.equalTo(strongSelf.backClear).offset(-30)
//
//
//            }
//        }

        UIView.animate(withDuration: 0.3, animations: { [unowned self] in

            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    
    func showPhotoImg(img:String,des:String,nikeName:String) {
        popWindow.addSubview(self)
        addSubview(backClear)
        backClear.addSubview(shareView)
        backClear.addSubview(sharePhotoView)
        
        sharePhotoView.imgPhoto.set_webimage_url(img)
        sharePhotoView.lbMyName.text = nikeName
        sharePhotoView.lbDes.text = des 
        shareView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(128)
            }
        }
        
        self.layoutIfNeeded()
        print("\(backClear.centerY)--\(shareView.centerY)--\(self.centerY)")
        
        sharePhotoView.snp.makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.centerY.equalTo((MGScreenHeight - 128) / 2)
                
                make.centerX.equalTo(strongSelf.backClear.centerX)
                
                make.left.equalTo(strongSelf.backClear).offset(30)
                make.right.equalTo(strongSelf.backClear).offset(-30)
                
                
            }
        }
       
      
        sharePhotoView.heightImgConstraint.constant = sharePhotoView.mj_w
        
          sharePhotoView.layoutIfNeeded()
         self.layoutIfNeeded()
//        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            
            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    func dismiss() {
        UIView.animate(withDuration: 0.3,animations: { [unowned self] in
            self.alpha = 0
            self.backClear.y = MGScreenHeight + 10;
        }, completion: { (ret) in
            self.backClear.removeFromSuperview()
            
            self.removeFromSuperview()
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
