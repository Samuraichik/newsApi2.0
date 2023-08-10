//
//  MainFlowCoordinator.swift
//  Randm
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Swinject


protocol AnyMainCoordinator: AnyCoordinator,
                             AnyMainTabBarCoordinator,
                             AnyArticlesCoordinator,
                             AnyFavoritesCoordinator,
                             AnyWebViewCoordinator,
                             AnyFiltersViewCoordinator {}

final class MainFlowCoordinator: AnyMainCoordinator, InjectableViaInit {    
    
    typealias Dependencies = (AnyScreenResolverOwner, AnyCoordinatorResolverOwner, AnySystemResolverOwner)
    
    // MARK: - Public Properties
    
    let screenResolverOwner: AnyScreenResolverOwner
    
    // MARK: - Private Properties
    
    private let coordinatorResolverOwner: AnyCoordinatorResolverOwner
    private let systemResolverOwner: AnySystemResolverOwner
    
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (screenResolverOwner, coordinatorResolverOwner, systemResolverOwner) = dependencies
    }
}

// MARK: - ICordinator

extension MainFlowCoordinator {
    public func start() {
        let window = systemResolverOwner.window
        window.makeKeyAndVisible()
        let controller = screenResolverOwner.mainTabBarScreen(with: self)
        
        window.rootViewController = controller
    }
}

// MARK: - AnyMainTabBarCoordinator

extension MainFlowCoordinator {
    func handle(event: MainTabBarCoordinatorEvent) {}
}

// MARK: - AnyArticlesCoordinator

extension MainFlowCoordinator {
    @MainActor
    func handle(event: ArticlesCoordinatorEvent) {
        Task {
            switch event {
            case .onTapOnCell(let url, let view):
                let controller = screenResolverOwner
                    .webViewScreen(with: self, url: url)
                
                view?.navigationController?.pushViewController(controller, animated: true)
            case .onTapFilters(view: let view):
                let controller = screenResolverOwner
                    .filtersViewScreen(with: self)
                
                controller.modalTransitionStyle = .flipHorizontal
                view?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - AnyFavoritesCoordinator

extension MainFlowCoordinator {
    func handle(event: FavoritesCoordinatorEvent) {}
}


// MARK: - AnyFavoritesCoordinator

extension MainFlowCoordinator {
    func handle(event: WebViewCoordinatorEvent) {}
}

// MARK: - AnyFiltersViewCoordinator

extension MainFlowCoordinator {
    @MainActor
    func handle(event: FiltersViewCoordinatorEvent) {
        Task {
            switch event {
            case .onClose(let view):
                view?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
