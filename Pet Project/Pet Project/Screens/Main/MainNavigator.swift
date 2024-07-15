//
//  MainNavigator.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxCocoa
import RxRelay

protocol IMainNavigator {
    func showArticleDetail(with model: ArticleModel)
}

struct MainNavigator: IMainNavigator {
    
    weak var viewController: IMainViewController!
    
    func showArticleDetail(with model: ArticleModel) {
        let vc = Dependency.resolve(with: IDetailViewController.self, with: .none, with: model)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}


