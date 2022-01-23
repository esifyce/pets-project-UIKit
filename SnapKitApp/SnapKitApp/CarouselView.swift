//
//  CarouselView.swift
//  SnapKitApp
//
//  Created by Sabir Myrzaev on 24.01.2022.
//

import UIKit

class CarouselView: UIView {

    private lazy var imageViewOne: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().offset((-(frame.width/2) - 20))
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var imageViewTwo: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.left.equalTo(imageViewOne.snp.right).offset(1)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview().offset((-(frame.height/2) - 1))
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageViewThree: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.left.equalTo(imageViewOne.snp.right).offset(1)
            $0.top.equalTo(imageViewTwo.snp.bottom).offset(1)
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imagesViews = [imageViewOne, imageViewTwo, imageViewThree]
    
    var model: Model? {
        didSet {
            if let model = model { setupView(model: model) }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(model: Model) {
        for (index, view) in imagesViews.enumerated() {
            let hasAnotherImage = model.images.count > index
            if hasAnotherImage { view.image = model.images[index] }
        }
    }
    
    struct Model {
        var images: [UIImage]
    }
}
