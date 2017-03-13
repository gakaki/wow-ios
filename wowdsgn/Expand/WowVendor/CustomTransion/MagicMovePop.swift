//
//  MagicMovePopTransion.swift
//  MagicMove
//
//  Created by Bing on 6/29/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class MagicMovePop: NSObject, UIViewControllerAnimatedTransitioning
{
    weak var selectView: UIImageView!
    weak var popController: UIViewController!
    
    init(popController: UIViewController!, selectView: UIImageView!) {
        super.init()
        self.selectView = selectView
        self.popController = popController
    }
    
    deinit {
        DLog("xiaohui")
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! WOWProductDetailController
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! VCTopic 
        let container = transitionContext.containerView
        
        let snapshotView = fromVC.selectedView
        snapshotView.frame = container.convert(fromVC.cycleView.frame, from: fromVC.tableView)
        fromVC.cycleView.isHidden = true
        
        popController.view.frame = transitionContext.finalFrame(for: popController)
        selectView.isHidden = true
        
        container.insertSubview(popController.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: {[weak self] () -> Void in
            if let strongSelf = self {
                snapshotView.frame = container.convert(strongSelf.selectView.frame, from: strongSelf.selectView
                    .superview)
                fromVC.view.alpha = 0
            }
            
        }) {[weak self] (finish: Bool) -> Void in
            if let strongSelf = self {
                strongSelf.selectView.isHidden = false
                snapshotView.removeFromSuperview()
                fromVC.cycleView.isHidden = false
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
    }
}
