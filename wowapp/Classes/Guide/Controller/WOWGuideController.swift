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
    
    private var scrollerView: UIScrollView!
    
    private let numOfPages = 3
    
    // 所有必要的状态
    enum State {
        case Standby
        case Register
        
        var description: String {
            switch self {
                case .Standby:
                    return "Standby"
                case .Register:
                    return "Register"
            }
        }
    }
    
    // 当前状态
    var currentState: State = .Standby {
        willSet {}
        
        didSet {
            
            var title1 = "加入我们"
            var title2 = "瞎逛逛"
            
            switch currentState {
                case .Standby: break
                
                case .Register:
                    title1 = "微信注册"
                    title2 = "手机注册"
            }
            
            btn1.setTitle(title1, forState: .Normal)
            btn2.setTitle(title2, forState: .Normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = self.view.bounds
        
        scrollerView = UIScrollView(frame:frame)
        scrollerView.pagingEnabled = true
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.scrollsToTop = false
        scrollerView.bounces = false
        scrollerView.contentOffset = CGPointZero
        //将scrollView的contentSize设为屏幕宽度的3倍
        scrollerView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages),height: frame.size.height)
        scrollerView.delegate = self
        
        for index in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "testinvitation"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, w: frame.size.width, h: frame.size.height)
            scrollerView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrollerView, atIndex: 0)
        pageControl.addTarget(self, action:#selector(WOWGuideController.didPage) , forControlEvents: UIControlEvents.TouchUpInside)
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        button.backgroundColor = .greenColor()
//        button.setTitle("Test Button", forState: .Normal)
//        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(button)
        
        currentState =  .Standby
    }
    
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button ")
    }
    
    
    @IBAction func btnSkipAction(sender: UIButton) {
        self.toMainVC()
    }
    
    @IBAction func btnLoginAction(sender: UIButton, forEvent event: UIEvent) {
        self.toLoginVC()
    }
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBAction func btn1Action(sender: UIButton, forEvent event: UIEvent) {
        
        if ( currentState == .Standby) {
            //播放动画
            currentState =  .Register
        }
        else if ( currentState == .Register) {
            //to weixin reg vc
           toWeixinVC()
            
        }
    }
 
    @IBAction func btn2Action(sender: UIButton, forEvent event: UIEvent) {
        
        if ( currentState == .Standby) {
            
            //进入首页
            toMainVC()
            
        }
        else if ( currentState == .Register) {
            //to mobile reg vc
            toRegVC()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
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
        let a =  UIApplication.sharedApplication().delegate as! AppDelegate
        return a
    }()
    
//MARK:Private Method
    override func setUI() {
        navigationItem.title = "尖叫设计"
       
    }
//MARK:Private pageController
    func didPage() {
        print(self.pageControl.currentPage)
        let frame = self.view.bounds
        let index = self.pageControl.currentPage
        let scrollPoint = CGPointMake(frame.size.width * CGFloat(index), 0)
        self.scrollerView.setContentOffset(scrollPoint, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension WOWGuideController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollerView.contentOffset
        pageControl.currentPage = Int(offset.x / view.bounds.width)
    }
}


