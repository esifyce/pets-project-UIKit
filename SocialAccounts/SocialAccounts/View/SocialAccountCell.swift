//
//  SocialAccountCell.swift
//  SocialAccounts
//
//  Created by Sabir Myrzaev on 13.02.2022.
//

import UIKit

class SocialAccountCell: UITableViewCell {
    static let identifier = "social_cell"

    var socialCell: SocialAccount? {
        didSet {
            guard let socialAccount = socialCell else { return }
            logoImageView.image = UIImage(named: socialAccount.imageURL)
            appTitle.text = socialAccount.title
            
            setupAppLink()
        }
    }
    
    fileprivate func setupAppLink() {
        guard let socialAccount = socialCell else { return }
        
        let attribs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            NSAttributedString.Key.underlineColor: UIColor.blue,
            NSAttributedString.Key.underlineStyle: 1,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        let str = NSAttributedString(string: socialAccount.url, attributes: attribs)
        
        appLink.setAttributedTitle(str, for: .normal)
    }
    
    @objc fileprivate func openApp() {
        guard let socialAccount = socialCell else { return }
        guard let appURL = URL(string: socialAccount.url) else { return }
        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    }
    
    fileprivate let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let appTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    fileprivate let appLink = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [appTitle,appLink])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        addSubview(logoImageView)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        appTitle.translatesAutoresizingMaskIntoConstraints = false
        appLink.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
