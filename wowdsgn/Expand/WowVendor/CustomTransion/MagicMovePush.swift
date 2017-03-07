//
//  MagicMoveTransion.swift
//  MagicMove
//
//  Created by Bing on 6/29/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class MagicMovePush: NSObject, UIViewControllerAnimatedTransitioning
{
    weak var selectView: UIImageView!
    
    
    init(selectView: UIImageView!) {
        super.init()
        self.selectView = selectView
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
        // 1.获取动画的源控制器和目标控制器
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! VCTopic
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! WOWProductDetailController
        let container = transitionContext.containerView
        
        // 2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
        let snapshotView = selectView.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = container.convert(selectView.frame, from: selectView.superview)
        selectView.isHidden = true
        
        // 3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.cycleView.isHidden = true
        
        // 4.都添加到 container 中。注意顺序不能错了
        container.addSubview(toVC.view)
        container.addSubview(snapshotView!)
        
        // 5.执行动画
        toVC.cycleView.layoutIfNeeded()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations:{ () -> Void in
            snapshotView!.frame = toVC.cycleView.frame
            toVC.view.alpha = 1
        }) {[weak self] (finish: Bool) -> Void in
            if let strongSelf = self {
                strongSelf.selectView.isHidden = false
                
                toVC.cycleView.isHidden = false
                snapshotView!.removeFromSuperview()
                
                //一定要记得动画完成后执行此方法，让系统管理 navigation
                transitionContext.completeTransition(true)
            }
            
        }
    }
}
