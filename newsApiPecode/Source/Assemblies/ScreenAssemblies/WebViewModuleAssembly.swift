//
//  MarketModuleAssembly.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import Swinject

final class WebViewModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(WebViewModel.self) { (_, flow: AnyWebViewCoordinator, url: String) in
            WebViewModel(dependencies: (
                flow,
                url
            ))
        }
        
        container.register(WebViewController.self) { (resolver, flow: AnyWebViewCoordinator, url: String) in
            let controller = WebViewController()

            controller.inject(dependencies:
                                resolver.resolve(flow, url)
            )
            
            return controller
        }
    }
}
