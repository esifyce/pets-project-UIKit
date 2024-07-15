//
//  BaseNavigationController.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private let transitionDelegate = AnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = transitionDelegate
        transitioningDelegate = self
    }
}

extension BaseNavigationController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionDelegate
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionDelegate
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

