//
//  WebViewModel.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation

enum WebViewCoordinatorEvent {}

protocol AnyWebViewCoordinator {
    func handle(event: WebViewCoordinatorEvent)
}

// MARK: - AnyWebViewViewModel Output & Input

struct WebViewVMOutput: AnyOutput {
    @MainThreadExecutable var urlFetched: EventHandler<String>
}

struct WebViewVMInput: AnyInput {
    let onViewWillAppear: VoidClosure
}

// MARK: - AnyWebViewViewModel

protocol AnyWebViewViewModel: AnyViewModel where Input == WebViewVMInput, Output == WebViewVMOutput {}

final class WebViewModel: AnyWebViewViewModel, InjectableViaInit {
    typealias Dependencies = (AnyWebViewCoordinator, String)
    
    // MARK: - Input/Output
    
    var output: WebViewVMOutput?
    private(set) lazy var input: WebViewVMInput? = {
        .init(
            onViewWillAppear: { [weak self] in
                guard let self = self else { return }
                self.output?.urlFetched(self.url)
            }
        )
    }()
    
    // MARK: - Private Properties
    
    private let coordinator: AnyWebViewCoordinator
    var url: String
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator, url) = dependencies
    }
}

