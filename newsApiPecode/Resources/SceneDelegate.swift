//
//  SceneDelegate.swift
//  newsApiPecode
//
//  Created by SSd on 08.08.2023.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    let utilsAssemblies: [Assembly] = [
        ServicesAssembly(),
        CoordinatorsAssembly(),
        SystemAssembly()
    ]
    
    let mainFlowAssemblies: [Assembly] = [
        MainTabBarModuleAssembly(),
        ArticlesModuleAssembly(),
        FavoritesModuleAssembly(),
        WebViewModuleAssembly(),
        FiltersModuleAssembly()
    ]
    
    lazy var appAssembler: Assembler = {
        $0.apply(assemblies: utilsAssemblies)
        $0.apply(assemblies: mainFlowAssemblies)
        return $0
    }(Assembler())
    
    lazy var resolver = appAssembler.resolver
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let coordinator = resolver.coordinatorResolverOwner.mainCoordinator()
        coordinator.start()
    }
}
