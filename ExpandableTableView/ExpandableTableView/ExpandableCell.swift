//
//  ExpandableCell.swift
//  ExpandableTableView
//
//  Created by Krasivo on 06.07.2022.
//

import UIKit

class ExpandableCell: UITableViewCell {
    var data: ExpandableData? {
        didSet {
            guard let data = data else { return }
            self.title.text = data.title
            self.subtitle.text = data.subtitle
            self.desctiption.text = data.description
        }
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "lorem ipsum"
        label.textColor = .blue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "lorem ipsum"
        label.textColor = .blue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let desctiption: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "lorem ipsum"
        label.textColor = .blue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let container: UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 8
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        
        setConstraints()
        

        container.addSubview(desctiption)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        container.addSubview(title)
        container.addSubview(subtitle)
        
        let constraints = [
           container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
           container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
           container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
           container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
           
           
           title.topAnchor.constraint(equalTo: container.topAnchor),
           title.leadingAnchor.constraint(equalTo: container.leadingAnchor),
           title.trailingAnchor.constraint(equalTo: container.trailingAnchor),
           title.heightAnchor.constraint(equalToConstant: 60),
           
           subtitle.topAnchor.constraint(equalTo: title.bottomAnchor),
           subtitle.leadingAnchor.constraint(equalTo: container.leadingAnchor),
           subtitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
           subtitle.heightAnchor.constraint(equalToConstant: 140),
           
//           desctiption.topAnchor.constraint(equalTo: container.topAnchor),
//           desctiption.leadingAnchor.constraint(equalTo: container.leadingAnchor),
//           desctiption.trailingAnchor.constraint(equalTo: container.trailingAnchor),
//           desctiption.heightAnchor.constraint(equalToConstant: 60),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    // MARK: - Helpers
    
    func animate() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: .curveLinear) {
            self.contentView.layoutIfNeeded()
        }
    }
}
