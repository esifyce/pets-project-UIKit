//
//  MainViewController.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxSwiftExt

protocol MainScreen: AnyObject {
    var viewModel: IMainViewModel! { get set }
}

typealias IMainViewController = BaseViewController & MainScreen

class MainViewController: IMainViewController {
    
    private let layout = MainCollectionLayout()
    
    private lazy var collectionView = Components.CollectionView(layout: layout)
        .build {
            $0.register(MainArticleCell.self)
        }
    
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<MainSection>(
        animationConfiguration: .fade
    ) { dataSource, collectionView, indexPath, viewModel in
        switch viewModel {
        case .content(let Article):
            let cell = collectionView.getReuseCell(indexPath: indexPath, type: MainArticleCell.self)
            cell.fill(with: Article)
            return cell
        }
    }
    
    var viewModel: IMainViewModel!
    
    override func setup() {
        super.setup()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.add {
            collectionView
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(
            .init(
                viewWillAppear: rx.viewWillAppear.asSignal()
            )
        )
        disposeBag.insert {
            output.articleSections.drive(collectionView.rx.items(dataSource: dataSource))
            output.logic.emit()
        }
    }
    
    override func applyLocalization() {
        super.applyLocalization()
        title = "News"
    }
}

