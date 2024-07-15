//
//  BaseImageView.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import Kingfisher

class BaseImageView: UIImageView {
    
    override var image: UIImage? {
        willSet {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.duration = 1/4
            layer.add(animation, forKey: CATransitionType.fade.rawValue)
        }
    }
        
    func setImage(
        with source: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = [.transition(.fade(1/5))],
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        kf.setImage(
            with: source,
            placeholder: placeholder,
            options: options,
            completionHandler: {
                switch $0 {
                case .success(let model):
                    completionHandler?(.success(model))
                case .failure(let model):
                    completionHandler?(.failure(model))
                }
            }
        )
    }
}
