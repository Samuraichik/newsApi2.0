//
//  ArticlesModuleAssembly.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation
import Swinject

final class ArticlesModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ArticlesViewModel.self) { (resolver, flow: AnyArticlesCoordinator) in
            ArticlesViewModel(dependencies: (
                flow,
                resolver.resolve()!,
                resolver.resolve()!,
                resolver.resolve()!,
                resolver.resolve()!
            ))
        }

        container.register(ArticlesViewController.self) { (resolver, flow: AnyArticlesCoordinator) in
            let controller = ArticlesViewController()
            controller.inject(dependencies: resolver.resolve(flow))

            return controller
        }
    }
}
