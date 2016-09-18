//
//  AdLaunchView.swift
//  DGAdLaunchView
//
//  Created by Desgard_Duan on 16/5/23.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyUserDefaults

@objc protocol AdLaunchViewDelegate: NSObjectProtocol {
    func adLaunchView(launchView: AdLaunchView, bannerImageDidClick imageURL: String)
}

private var sloganHeight: CGFloat = 128

final class AdLaunchView: UIView {
    
    weak var delegate: AdLaunchViewDelegate?
    
    // 启动广告背景
    private lazy var adBackground: UIView = {
        let wid = UIScreen.mainScreen().bounds.width
        let hei = UIScreen.mainScreen().bounds.height
        
        var footer: UIView = UIView(frame: CGRectMake(0, hei - sloganHeight, wid, sloganHeight))
        footer.backgroundColor = UIColor.whiteColor()
        
        var slogan: UIImageView = UIImageView(image: UIImage(named: "KDTKLaunchSlogan_Content"))
        footer.addSubview(slogan)
        
        slogan.snp_makeConstraints(closure: { (make) in
            make.center.equalTo(footer)
        })
        
        var view: UIView = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(footer)
        return view
    }()
    
    // 图片链接
    private var imageURL: String = "http://mg.soupingguo.com/bizhi/big/10/258/043/10258043.jpg"
    
    // 启动页广告
    private var adImageView: UIImageView?

    // 进度条
    private var progressView: DACircularProgressView?
    
    // 跳过广告按钮
    private var progressButtonView: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(adBackground)
        
        //使用网络图
        if let downPic = Defaults[.pic_ad]{
            self.imageURL = downPic
        }
        
        
        // 广告主流程
        displayCachedAd()
        requestBanner()
        showProgressView()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.removeFromSuperview()
        }
    }
    
    override func removeFromSuperview() {
        UIView.animateWithDuration(1, animations: {
                self.alpha = 0
            }) { (finished: Bool) in
                super.removeFromSuperview()
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private
private extension AdLaunchView {
    
    func displayCachedAd() {
        let manange: SDWebImageManager = SDWebImageManager()
        if (((manange.imageCache.imageFromDiskCacheForKey(imageURL)) == nil)) {
            self.hidden = true
        } else {
            showImage()
        }
    }
    
    func requestBanner() {
        SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: self.imageURL), options: SDWebImageOptions.AvoidAutoSetImage, progress: nil) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url:NSURL!) in
            print("图片下载成功")
        }
        
        
    }
    
    func showImage() {
        adImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - sloganHeight))
        if let adImageView = adImageView {
            adImageView.sd_setImageWithURL(NSURL(string: imageURL))
            adImageView.userInteractionEnabled = true
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AdLaunchView.singleTapAction))
            adImageView.addGestureRecognizer(singleTap)
            
            addSubview(adImageView)
        }
    }
    
    func showProgressView() {
        progressButtonView = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60, 20, 40, 40))
        if let progressButtonView = progressButtonView {
            progressButtonView.setTitle("跳", forState: .Normal)
            progressButtonView.titleLabel?.textAlignment = .Center
            progressButtonView.backgroundColor = UIColor.clearColor()
            progressButtonView.addTarget(self, action: #selector(toHidenState), forControlEvents: .TouchUpInside)
            addSubview(progressButtonView)
        }
        
        progressView = DACircularProgressView(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 60, 20, 40, 40))
        if let progressView = progressView {
            progressView.userInteractionEnabled = false
            progressView.progress = 0
            addSubview(progressView)
            progressView.setProgress(1, animated: true, initialDelay: 0, withDuration: 4)
        }
    }
    
    @objc func singleTapAction() {
        self.delegate?.adLaunchView(self, bannerImageDidClick: imageURL)
        toHidenState()
    }
    
    @objc func toHidenState() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0
        }) { (finished: Bool) in
            self.hidden = true
        }
    }
}
