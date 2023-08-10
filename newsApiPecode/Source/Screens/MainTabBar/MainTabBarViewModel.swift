//
//  MainTabBarViewModel.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import UIKit

// MARK: - AnyMainTabBarCoordinator

enum MainTabBarCoordinatorEvent {}

protocol AnyMainTabBarCoordinator {
    func handle(event: MainTabBarCoordinatorEvent)
}

// MARK: - AnyLoginViewModel Output & Input

struct MainTabBarVMOutput: AnyOutput {}

struct MainTabBarVMInput: AnyInput {}

// MARK: - AnyLoginViewModel

protocol AnyMainTabBarViewModel: AnyViewModel where Input == MainTabBarVMInput, Output == MainTabBarVMOutput {}

final class MainTabBarViewModel: AnyMainTabBarViewModel, InjectableViaInit {
    typealias Dependencies = AnyMainTabBarCoordinator

    private(set) var input: MainTabBarVMInput?
    var output: MainTabBarVMOutput?

    // MARK: - Private Properties

    private let coordinator: AnyMainTabBarCoordinator
    
    // MARK: - Init
    
    init(dependencies: AnyMainTabBarCoordinator) {
        coordinator = dependencies
    }
}
