//
//  DetailViewController.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol DetailScreen: AnyObject {
    var viewModel: IDetailViewModel! { get set }
}

typealias IDetailViewController = BaseViewController & DetailScreen

class DetailViewController: IDetailViewController {
    
    private let imageView = Components.ImageView.base
        .contentMode(.scaleAspectFit)
        .build()
    
    private let authorLabel = Components.Label.base
        .font(.systemFont(ofSize: 20))
        .textColor(.black)
        .build()
    
    private let contentLabel = Components.Label.base
        .font(.systemFont(ofSize: 20))
        .textColor(.black)
        .build()
    
    var viewModel: IDetailViewModel!
    
    override func setup() {
        super.setup()
        view.backgroundColor = .white
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.add {
            imageView
            authorLabel
            contentLabel
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(
            .init(viewWillAppear: rx.viewWillAppear.asSignal())
        )
        disposeBag.insert {
            output.title.drive(rx.title)
            output.author.drive(authorLabel.rx.text)
            output.content.drive(contentLabel.rx.text)
            output.imageURL.drive(
                onNext: { [unowned self] in
                    imageView.setImage(with: $0) { [unowned self] result in
                        guard case let .success(imageResult) = result else { return }
                        let size = imageResult.image.size
                        let fraction = size.height / size.width
                        imageView.snp.updateConstraints { make in
                            make.height.equalTo(view.frame.width * fraction)
                        }
                    }
                }
            )
            output.logic.emit()
        }
    }
}

