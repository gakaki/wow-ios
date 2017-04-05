//
//  WOWGuidePageView.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/5.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWGuidePageView: UIView {
    
    var imgArr = [String]()
    var scrollView:UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(datas:Array<String>) {
        self.init()
        self.frame = CGRect(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight)
        self.imgArr = datas
        setupUI()
    
    }
    
    func showView() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.alpha = 1
        }
    }
    
    func setupUI() {
        
        // This houses all of the UIViews / content
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.frame = self.frame
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        self.addSubview(scrollView)
        
        self.scrollView.contentSize = CGSize(width: MGScreenWidth * 3, height: MGScreenHeight)
        
        //根据数据数量来动态创建视图
        let size = imgArr.count
        for count in 0 ..<  size{
            
            //设置左边距离，根据数据对应数组的位置
            let index = CGFloat(count)
            let lBounds = MGScreenWidth * index
            let path = imgArr[count]
            let image = UIImage(named: path as String)
            let insets=UIEdgeInsetsMake(0, 0, 0, 0)
            //这里设置图片拉伸
            image?.resizableImage(withCapInsets: insets, resizingMode: UIImageResizingMode.stretch)
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x: lBounds, y: 0, width: MGScreenWidth, height: MGScreenHeight)
            scrollView.addSubview(imageView)
            
            if(count == size-1){
                let btnSubmit = UIButton(type: .custom)
                btnSubmit.setTitle("立即进入", for: .normal)
                btnSubmit.titleLabel?.font = UIFont.AvenirNext(type: .Medium, size: 16)
                btnSubmit.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
                btnSubmit.borderColor(1.5, borderColor: UIColor.init(hexString: "#333333")!)
                btnSubmit.addTarget(self, action: #selector(hideView), for: .touchUpInside)
                imageView.addSubview(btnSubmit)
                btnSubmit.snp.makeConstraints({(make) in
                    make.left.equalTo(imageView).offset(30)
                    make.right.bottom.equalTo(imageView).offset(-30)
                    make.height.equalTo(44)
                })
            }
            self.scrollView.bringSubview(toFront: imageView)
        }
        
        let btnClose = UIButton(type: .custom)
        btnClose.setImage(UIImage(named: "close"), for: .normal)
        btnClose.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        btnClose.contentVerticalAlignment = .top
        btnClose.contentHorizontalAlignment = .left
        btnClose.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 0, right: 0)
        self.addSubview(btnClose)
        btnClose.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(0)
            make.width.equalTo(60)
            make.height.equalTo(45)
        }
        
    }
    
    func hideView(){
        
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
