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
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! WOWProductDetailController
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! VCTopic
        let container = transitionContext.containerView
        
        let snapshotView = fromVC.cycleView.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = container.convert(fromVC.cycleView.frame, from: fromVC.tableView)
        fromVC.cycleView.isHidden = true
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.selectedCell.pictureImageView.isHidden = true
        
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshotView!)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            snapshotView?.frame = container.convert(toVC.selectedCell.pictureImageView.frame, from: toVC.selectedCell)
            fromVC.view.alpha = 0
        }) { (finish: Bool) -> Void in
            toVC.selectedCell.pictureImageView.isHidden = false
            snapshotView?.removeFromSuperview()
            fromVC.cycleView.isHidden = false
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
