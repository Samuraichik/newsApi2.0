//
//  MainTabBarModuleAssembly.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.12.2022.
//

import Swinject
import UIKit

final class MainTabBarModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainTabBarViewModel.self) { (resolver, flow: AnyMainCoordinator) in
            MainTabBarViewModel(
                dependencies: (flow)
            )
        }
        
        container.register(MainTabBarViewController.self) { (resolver, flow: AnyMainCoordinator) in
            let controller = MainTabBarViewController()
            controller.inject(dependencies: resolver.resolve(flow)!)
            
            let articlesController = resolver.screenResolverOwner.articleScreen(with: flow)
            let favoriteController = resolver.screenResolverOwner.favoriteScreen(with: flow)
            
            let articlesNavigationController = UINavigationController(rootViewController: articlesController)
            let favoriteNavigationController = UINavigationController(rootViewController: favoriteController)
            
            articlesNavigationController.tabBarItem = TabBarItemConfig.articles.tabBarItem
            favoriteNavigationController.tabBarItem = TabBarItemConfig.favourite.tabBarItem
            
            controller.viewControllers = [
                articlesNavigationController,
                favoriteNavigationController,
            ]
            
            return controller
        }
    }
}

extension MainTabBarModuleAssembly {
    enum TabBarItemConfig {
        case articles
        case favourite
        
        var image: UIImage {
            switch self {
            case .articles: return UIImage(named: "homeIconn")!
            case .favourite: return UIImage(named: "favoritePicked")!
            }
        }
        
        var tabBarItem: UITabBarItem {
            let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: image)
            tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            return tabBarItem
        }
    }
}
