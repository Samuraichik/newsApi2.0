//
//  File.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.11.2022.
//

import Swinject

protocol AnyCoordinatorResolverOwner: AnyResolverOwner {
    func mainCoordinator() -> AnyMainCoordinator
}

extension AnyCoordinatorResolverOwner {
    func mainCoordinator() -> AnyMainCoordinator {
        resolver.resolve(AnyMainCoordinator.self)!
    }
}
