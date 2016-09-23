
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
    func adLaunchView(_ launchView: AdLaunchView, bannerImageDidClick imageURL: String)
}

private var sloganHeight: CGFloat = 128

final class AdLaunchView: UIView {
    
    weak var delegate: AdLaunchViewDelegate?
    
    // 启动广告背景
    fileprivate lazy var adBackground: UIView = {
        let wid = UIScreen.main.bounds.width
        let hei = UIScreen.main.bounds.height
        
        var footer: UIView = UIView(frame: CGRect(x: 0, y: hei - sloganHeight, width: wid, height: sloganHeight))
        footer.backgroundColor = UIColor.white
        
        var slogan: UIImageView = UIImageView(image: UIImage(named: "KDTKLaunchSlogan_Content"))
        footer.addSubview(slogan)
        
        slogan.snp_makeConstraints({ (make) in
            make.center.equalTo(footer)
        })
        
        var view: UIView = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        view.addSubview(footer)
        return view
    }()
    
    // 图片链接
    fileprivate var imageURL: String = "http://mg.soupingguo.com/bizhi/big/10/258/043/10258043.jpg"
    
    // 启动页广告
    fileprivate var adImageView: UIImageView?

    // 进度条
    fileprivate var progressView: DACircularProgressView?
    
    // 跳过广告按钮
    fileprivate var progressButtonView: UIButton?
    
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
        
        let delayTime = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.removeFromSuperview()
        }
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 1, animations: {
                self.alpha = 0
            }, completion: { (finished: Bool) in
                super.removeFromSuperview()
            }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private
private extension AdLaunchView {
    
    func displayCachedAd() {
        let manange: SDWebImageManager = SDWebImageManager()
        if (((manange.imageCache.imageFromDiskCache(forKey: imageURL)) == nil)) {
            self.isHidden = true
        } else {
            showImage()
        }
    }
    
    func requestBanner() {
        //TODO:SDWEBImage
//        SDWebImageManager.shared().downloadImage(with: URL(string: self.imageURL), options: SDWebImageOptions.avoidAutoSetImage, progress: nil) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url:URL!) in
//            print("图片下载成功")
//        }
        
        
    }
    
    func showImage() {
        adImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - sloganHeight))
        if let adImageView = adImageView {
            adImageView.sd_setImage(with: URL(string: imageURL))
            adImageView.isUserInteractionEnabled = true
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AdLaunchView.singleTapAction))
            adImageView.addGestureRecognizer(singleTap)
            
            addSubview(adImageView)
        }
    }
    
    func showProgressView() {
        progressButtonView = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 20, width: 40, height: 40))
        if let progressButtonView = progressButtonView {
            progressButtonView.setTitle("跳", for: UIControlState())
            progressButtonView.titleLabel?.textAlignment = .center
            progressButtonView.backgroundColor = UIColor.clear
            progressButtonView.addTarget(self, action: #selector(toHidenState), for: .touchUpInside)
            addSubview(progressButtonView)
        }
        
        progressView = DACircularProgressView(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 20, width: 40, height: 40))
        if let progressView = progressView {
            progressView.isUserInteractionEnabled = false
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
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            self.isHidden = true
        }) 
    }
}
