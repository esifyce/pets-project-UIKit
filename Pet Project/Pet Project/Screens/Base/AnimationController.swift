//
//  AnimationController.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

class AnimationController: NSObject {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval = 1/4) {
        self.duration = duration
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toView = toViewController.view,
            let _ = fromViewController.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.alpha = 1
        } completion: {
            transitionContext.completeTransition($0)
        }
    }
}

extension AnimationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
