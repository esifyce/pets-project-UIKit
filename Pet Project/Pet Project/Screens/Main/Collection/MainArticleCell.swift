//
//  MainArticleCell.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import UIKit
import SnapKit
import RxCocoa
import RxGesture

class MainArticleCell: BaseCollectionViewCell {
    
    private let imageView = Components.ImageView.base
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .build()
    
    override func setup() {
        super.setup()
        clipsToBounds = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        contentView.add {
            imageView
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func fill(with article: MainSection.Article) {
        disposeBag = .init()
        
        let url = URL(string: article.model.urlToImage ?? "")
        imageView.setImage(with: url)
        
        let tap = rx.tapGesture().when(.recognized).asSignal(onErrorSignalWith: .empty()).voidType()
        disposeBag?.insert {
            article.tap.transform(tap).emit()
        }
    }
}
