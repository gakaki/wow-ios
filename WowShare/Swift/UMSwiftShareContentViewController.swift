//
//  UMSwiftShareContentViewController.swift
//  UMSocialDemo
//
//  Created by umeng on 16/10/11.
//  Copyright © 2016年 Umeng. All rights reserved.
//

import UIKit
import UShareUI

public class UMSwiftShareContentViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
    
        
        let shareButton:UIButton = UIButton(frame: CGRect(x: 50, y: 50, width: 200, height: 50))
        shareButton.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        shareButton.setTitle("Swift调用分享面板", for: UIControlState())
        shareButton.addTarget(self, action: #selector(UMSwiftShareContentViewController.shareAction), for: UIControlEvents.touchUpInside)
        shareButton.setTitleColor(UIColor.blue, for: UIControlState())
        shareButton.backgroundColor = UIColor.clear
        self.view.addSubview(shareButton)
//
//        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    public func shareAction (){
        
        
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) -> Void in

            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "社会化组件UShare将各大社交平台接入您的应用，快速武装App。"//分享的文本
            
            /*
            //1.分享图片
            var shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.title = "Umeng分享"//显不显示有各个平台定
            shareObject.descr = "描述信息"//显不显示有各个平台定
            shareObject.thumbImage = UIImage.init(named: "icon")//显不显示有各个平台定
            shareObject.shareImage = "http://dev.umeng.com/images/tab2_1.png"
            messageObject.shareObject = shareObject;
            */
            
            //2.分享分享网页
            let shareObject:UMShareWebpageObject = UMShareWebpageObject.init()
            shareObject.title = "分享标题"//显不显示有各个平台定
            shareObject.descr = "描述信息"//显不显示有各个平台定
            shareObject.thumbImage = UIImage.init(named: "icon")//缩略图，显不显示有各个平台定
            shareObject.webpageUrl = "http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"
            messageObject.shareObject = shareObject;

            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) -> Void in
                if error != nil {
                    print("Share Fail with error ：%@", error)
                }else{
                    print("Share succeed")
                }

            })
            
        }
    }
//
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


