//
//  WOWIntroduceController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/28.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWIntroduceController: WOWBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func setUI() {
        super.setUI()
        let imageNames = ["intro01","intro02","intro03"]
        for index in 0...2 {
            var name = imageNames[index]
            if UIDevice.deviceType.rawValue <= 1{
                name = name + "_4"
            }
            let imageView = UIImageView(frame:CGRectMake(MGScreenWidth * CGFloat(index), 0, MGScreenWidth, MGScreenHeight))
            imageView.image = UIImage(named: name)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSizeMake(MGScreenWidth * CGFloat(3), 0)
    }
}


extension WOWIntroduceController:UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / MGScreenWidth
        pageController.currentPage = Int(index)
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        DLog(scrollView.contentOffset.x)
        if scrollView.contentOffset.x >= MGScreenWidth * 2{
            
            let sideVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(WOWLeftSideController))
            let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
            let sideController = WOWSideContainerController(sideViewController:sideVC, mainViewController:mainVC)
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.sideController = sideController
            self.presentViewController(sideController, animated: true, completion: nil)
        }
    }



}


