//
//  FavoritesModuleAssembly.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 09.08.2023.
//

import Foundation
import Swinject

final class FavoritesModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FavoritesViewModel.self) { (resolver, flow: AnyFavoritesCoordinator) in
            FavoritesViewModel(dependencies: (
                flow,
                resolver.resolve()!
            ))
        }
        
        container.register(FavoritesViewController.self) { (resolver, flow: AnyFavoritesCoordinator) in
            let controller = FavoritesViewController()
            controller.inject(dependencies: resolver.resolve(flow))
            
            return controller
        }
    }
}
