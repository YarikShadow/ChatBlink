//
//  TransitionManager.swift
//  ChatBlink
//
//  Created by Admin on 09/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {

    // MARK: методы протокола UIViewControllerAnimatedTransitioning
    
    // метод, в котором непосредственно указывается анимация перехода от одного  viewcontroller к другому
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // код анимации
        // 1
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        // 3
        toView.transform = offScreenRight
        
        // 4
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // 5
        let duration = self.transitionDuration(using: transitionContext)
        
        // 6
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.49, initialSpringVelocity: 0.81, options: [], animations: { () -> Void in
            fromView.transform = offScreenLeft
            toView.transform = CGAffineTransform.identity
        }) { (finished) -> Void in
            // 7
            transitionContext.completeTransition(true)
        }
    }
    
    // метод возвращает количество секунд, которые длится анимация
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    // MARK: методы протокола UIViewControllerTransitioningDelegate
    
    // аниматор для презентации viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // аниматор для скрытия viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
