//
//  Dependency.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import Swinject

enum DependencyNames: String {
    case mainWindow
    case databaseDirectory
    case baseURL
}

struct Dependency {
    
    static let container = Container() { container in
        registerAll(with: container)
    }
    
    static func registerAll(with container: Container) {
        container.registerService(UIWindow.self, dependencyName: .mainWindow, objectScope: .container) { _ in
            UIWindow(frame: UIScreen.main.bounds)
        }
        container.register(TokenPlugin.self) { _ in
            TokenPlugin()
        }
        container.registerService(URL.self, dependencyName: .databaseDirectory) { _ in
            Config.databaseDirectoryURL
        }
        container.registerService(URL.self, dependencyName: .baseURL) { _ in
            Config.baseURL
        }
        registerRealmMigrator(with: container)
        
        registerArticlesUseCase(with: container)
        
        registerArticleCacheUseCase(with: container)
        
        regiterScreens(with: container)
    }
    
    static func resolve<Service>(
        with serviceType: Service.Type = Service.self,
        with dependancyName: DependencyNames? = nil,
        with arguements: Any? = nil
    ) -> Service {
        if let arguements {
            return container.resolve(serviceType, name: dependancyName?.rawValue, argument: arguements)!
        } else {
            return container.resolve(serviceType, name: dependancyName?.rawValue)!
        }
    }
}

extension Dependency {
    
    static func regiterScreens(with container: Container) {
        
        // MARK: - Main
        
        container.register(IMainNavigator.self) { (resolver, vc: IMainViewController) in
            MainNavigator(viewController: vc)
        }
        container.register(IMainViewModel.self) { (resolver, vc: IMainViewController) in
            MainViewModel(
                navigator: resolver.resolve(IMainNavigator.self, argument: vc)!,
                articlesUseCase: resolver.resolve(IArticlesUseCase.self)!,
                articlesCacheUseCase: resolver.resolve(IArticlesCacheUseCase.self)!
            )
        }
        container.register(IMainViewController.self) { resolver in
            MainViewController()
        }.initCompleted {
            $1.viewModel = $0.resolve(IMainViewModel.self, argument: $1)
        }
        
        
        // MARK: - Detail
        
        container.register(IDetailNavigator.self) { (resolver, vc: IDetailViewController) in
            DetailNavigator(viewController: vc)
        }
        container.register(IDetailViewModel.self) { (resolver, vc: IDetailViewController, model: Any) in
            DetailViewModel(
                navigator: resolver.resolve(IDetailNavigator.self, argument: vc)!,
                model: model as! ArticleModel
            )
        }
        container.register(IDetailViewController.self) { (resolver, arg: Any) in
            let vc = DetailViewController()
            vc.viewModel = resolver.resolve(IDetailViewModel.self, arguments: vc as IDetailViewController, arg)
            return vc
        }
    }
}

private struct Config {
    static let databaseDirectoryURL = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask).first!
        .appendingPathComponent("pet-project-database", isDirectory: true)
    
    static let baseURL = URL(string: "https://newsapi.org/")!
}

extension Container {
    func registerService<Service>(
        _ serviceType: Service.Type,
        dependencyName: DependencyNames? = nil,
        objectScope: ObjectScope = .graph,
        factory: @escaping (Resolver) -> Service
    ) {
        register(serviceType, name: dependencyName?.rawValue, factory: factory).inObjectScope(objectScope)
    }
}
