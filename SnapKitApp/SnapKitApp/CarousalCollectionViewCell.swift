//
//  CarousalCollectionViewCell.swift
//  SnapKitApp
//
//  Created by Sabir Myrzaev on 24.01.2022.
// 

import UIKit

class CarousalCollectionViewCell: UICollectionViewCell {
    static let identifier = "CarouselCollectionCell"
    
    private let carouselPadding: CGFloat = 60.0
    
    private lazy var carouselView: CarouselView = {
        let frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - carouselPadding)
        let carouselView = CarouselView(frame: frame)
        contentView.addSubview(carouselView)
        
        carouselView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(carouselPadding)
        }
        return carouselView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.top.equalTo(carouselView.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(20)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(carouselView.snp.bottom).offset(4)
            $0.right.equalTo(likeButton.snp.left).inset(8)
        }
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.right.equalTo(likeButton.snp.left).inset(8)
        }
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var cellModel: Model? {
        didSet {
            setupUI(cellModel: cellModel)
        }
    }
    
    func setupUI(cellModel: Model?) {
        guard let cellModel = cellModel else { return }
        carouselView.model = cellModel.model
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        let image = cellModel.liked ? UIImage(named: "heartFill") : UIImage(named: "heartEmpty")
        likeButton.setImage(image, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Model {
        var title: String?
        var description: String?
        var liked: Bool
        var model: CarouselView.Model?
    }
    
    override func prepareForReuse() {
        cellModel = nil
    }
}
