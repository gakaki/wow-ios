//
//  WOWController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWGuideController: WOWBaseViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var skipButton:  UIButton!
    
    fileprivate var scrollerView: UIScrollView!
    
    fileprivate let numOfPages = 1
    
    // 所有必要的状态
    enum State {
        case standby
        case register
        
        var description: String {
            switch self {
                case .standby:
                    return "Standby"
                case .register:
                    return "Register"
            }
        }
    }
    
    // 当前状态
    var currentState: State = .standby {
        willSet {}
        
        didSet {
            
            var title1 = "加入我们"
            var title2 = "先逛逛"
            var backGroundColor1 = MGRgb(32, g: 32, b: 32)
            var backGroundColor2 = UIColor.white
            var titleColor1 = UIColor.white
            var titleColor2 = UIColor.black
            
            
            switch currentState {
                case .standby: break
                
                case .register:
                    title1 = "绑定微信"
                    title2 = "手机注册"
                backGroundColor1 = UIColor.whiteColor()
                backGroundColor2 = UIColor.white
                titleColor1 = UIColor.black
                titleColor2 = UIColor.black
            }
//            btn2.borderColor(1, borderColor:UIColor.whiteColor())
            
            btn1.setTitle(title1, for: UIControlState())
            btn2.setTitle(title2, for: UIControlState())
            btn1.backgroundColor = backGroundColor1
            btn2.backgroundColor = backGroundColor2
            btn1.setTitleColor(titleColor1,for: UIControlState()) //普通状态下文字的颜色
            btn2.setTitleColor(titleColor2,for: UIControlState()) //普通状态下文字的颜色
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        
        scrollerView = UIScrollView(frame:frame)
        scrollerView.isPagingEnabled = true
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.scrollsToTop = false
        scrollerView.bounces = false
        scrollerView.contentOffset = CGPoint.zero
        //将scrollView的contentSize设为屏幕宽度的3倍
        scrollerView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages),height: frame.size.height)
        scrollerView.delegate = self
        
        for index in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "guideBackground"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, w: frame.size.width, h: frame.size.height)
            scrollerView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrollerView, at: 0)
        pageControl.addTarget(self, action:#selector(WOWGuideController.didPage) , for: UIControlEvents.touchUpInside)
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        button.backgroundColor = .greenColor()
//        button.setTitle("Test Button", forState: .Normal)
//        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(button)
        
        currentState =  .standby
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func buttonAction(_ sender: UIButton!) {
    }
    
    
    @IBAction func btnSkipAction(_ sender: UIButton) {
        self.toMainVC()
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton, forEvent event: UIEvent) {
        self.toLoginVC()
    }
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBAction func btn1Action(_ sender: UIButton, forEvent event: UIEvent) {
        
        if ( currentState == .standby) {
            //播放动画
            
            UIView.animate(withDuration: 0.5, animations: {
                self.btn1.y += 50
                self.btn1.alpha = 0.0
                self.btn2.y += 50
                self.btn2.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    self.currentState =  .register
                    UIView.animate(withDuration: 0.5, animations: {
                        self.btn1.y -= 50
                        self.btn1.alpha = 1.0
                        self.btn2.y -= 50
                        self.btn2.alpha = 1.0
                        }, completion: { (finished:Bool) -> Void in
                            
                    })
            })
        }
        else if ( currentState == .register) {
            //to weixin reg vc
           toWeixinVC()
            
        }
    }
 
    @IBAction func btn2Action(_ sender: UIButton, forEvent event: UIEvent) {
        
        if ( currentState == .standby) {
            
            //进入首页
            toMainVC()
            
        }
        else if ( currentState == .register) {
            //to mobile reg vc
//            toRegVC()
            toRegVC(userInfoFromWechat: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Lazy
    lazy var appdelegate:AppDelegate = {
        let a =  UIApplication.shared.delegate as! AppDelegate
        return a
    }()
    
//MARK:Private Method
    override func setUI() {
        navigationItem.title = "尖叫设计"
       
    }
//MARK:Private pageController
    func didPage() {
        let frame = self.view.bounds
        let index = self.pageControl.currentPage
        let scrollPoint = CGPoint(x: frame.size.width * CGFloat(index), y: 0)
        self.scrollerView.setContentOffset(scrollPoint, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension WOWGuideController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollerView.contentOffset
        pageControl.currentPage = Int(offset.x / view.bounds.width)
    }
}


