//
//  ResolverOwner.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Swinject

final class ResolverOwner: AnyServiceResolverOwner,
                           AnyScreenResolverOwner,
                           AnyCoordinatorResolverOwner,
                           AnySystemResolverOwner,
                           InjectableViaInit {
    
    typealias Dependencies = Resolver
    
    let resolver: Resolver
    
    init(dependencies: Dependencies) {
        resolver = dependencies
    }
}
