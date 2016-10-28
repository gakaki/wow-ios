//
//  pagingScrollView.swift
//  WOWScrollView
//
//  Created by 陈旭 on 2016/10/19.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
import SnapKit
class PagingScrollView: UIView {

    fileprivate var widthContraint:Constraint? = nil
    fileprivate var heightContraint:Constraint? = nil
    
    open var pagingWidth:CGFloat = 0 {
        didSet {
            if pagingWidth.isZero {
                widthContraint?.activate()
            }
            else {
                widthContraint?.deactivate()
                self.scrollView.snp.updateConstraints{ (make) -> Void in
                    make.width.equalTo(self.pagingWidth)
                }
            }
        }
    }
    
    open var pagingHeight:CGFloat = 0 {
        didSet {
            if pagingHeight.isZero {
                heightContraint?.activate()
            }
            else {
                heightContraint?.deactivate()
                self.scrollView.snp.updateConstraints{ (make) -> Void in
                    make.height.equalTo(self.pagingHeight)
                }
            }
        }
    }
    open var cardCount:CGFloat = 0 {
        didSet {
            if cardCount == 1 {
                self.pageControl.isHidden = true
            }else{
                self.pageControl.numberOfPages = Int(cardCount)
                self.pageControl.currentPage = 0
            }
        }
    }

    
    fileprivate class ReachableScrollView:UIScrollView {
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return true
        }
        
    }
    
    open lazy var scrollView:UIScrollView! = {
        var v = ReachableScrollView()
        v.clipsToBounds = false
        v.isPagingEnabled = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        return v
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    fileprivate func setup() {
        
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        self.scrollView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.width.equalTo(self.pagingWidth)
            make.height.equalTo(self.pagingHeight)
            self.widthContraint = make.width.equalTo(self.snp.width).constraint
            self.heightContraint = make.height.equalTo(self.snp.height).constraint
        }
        self.pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
    }
    
    open lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.autoresizingMask = UIViewAutoresizing(rawValue: UInt(0))
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor(hexString: "000000", alpha: 0.2)!
        return pageControl
    }()

}
extension PagingScrollView:UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }}
