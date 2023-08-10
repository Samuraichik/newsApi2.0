//
//  AnyScreenResolverOwner.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.11.2022.
//

import Swinject

protocol AnyScreenResolverOwner: AnyResolverOwner {
    func mainTabBarScreen(with flow: AnyMainCoordinator) -> MainTabBarViewController
    func articleScreen(with flow: AnyArticlesCoordinator) -> ArticlesViewController
    func favoriteScreen(with flow: AnyFavoritesCoordinator) -> FavoritesViewController
    func webViewScreen(with flow: AnyWebViewCoordinator, url: String) -> WebViewController
    func filtersViewScreen(with flow: AnyFiltersViewCoordinator) -> FiltersViewController
}

extension AnyScreenResolverOwner {
    // MARK: - Main Flow
    
    func mainTabBarScreen(with flow: AnyMainCoordinator) -> MainTabBarViewController {
        resolver.resolve(flow)
    }
    
    func articleScreen(with flow: AnyArticlesCoordinator) -> ArticlesViewController {
        resolver.resolve(flow)
    }
    
    func favoriteScreen(with flow: AnyFavoritesCoordinator) -> FavoritesViewController {
        resolver.resolve(flow)
    }

    func webViewScreen(with flow: AnyWebViewCoordinator, url: String) -> WebViewController {
        resolver.resolve(flow, url)
    }
    
    func filtersViewScreen(with flow: AnyFiltersViewCoordinator) -> FiltersViewController {
        resolver.resolve(flow)
    }
}
