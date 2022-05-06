//
//  HabitantsCollectionViewCell.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 1/5/22.
//

import UIKit

class HabitantsCollectionViewCell: UICollectionViewCell {
    static let identifier = "habitantsCell"
    
    // MARK: - View
    
    private let entityMarine: UIImageView = {
        let entity = UIImageView()
        entity.image = UIImage(named: "empty")
        entity.clipsToBounds = true
        entity.contentMode = .scaleAspectFill
        return entity
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interection with data for cell
    func configure(image: String) {
        entityMarine.image = UIImage(named: image)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        entityMarine.image = nil
    }
    
    // MARK: - Helpers
    private func configureUI() {
        contentView.addSubview(entityMarine)
        setConstraints()
    }
    
    private func setConstraints() {
        entityMarine.apply(top: contentView.safeAreaLayoutGuide.topAnchor,
                           left: contentView.safeAreaLayoutGuide.leadingAnchor,
                           bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
                           right: contentView.safeAreaLayoutGuide.trailingAnchor)
    }
}
