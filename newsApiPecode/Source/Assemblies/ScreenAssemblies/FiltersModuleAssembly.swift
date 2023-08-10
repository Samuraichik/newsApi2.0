//
//  FiltersModuleAssembly.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import Foundation
import Swinject

final class FiltersModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FiltersViewModel.self) { (resolver, flow: AnyFiltersViewCoordinator) in
            FiltersViewModel(dependencies: (
                flow,
                resolver.resolve()!
            ))
        }
        
        container.register(FiltersViewController.self) { (resolver, flow: AnyFiltersViewCoordinator) in
            let controller = FiltersViewController()

            controller.inject(dependencies:
                                resolver.resolve(flow)
            )
            
            return controller
        }
    }
}
