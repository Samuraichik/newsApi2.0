//
//  WebViewController.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import UIKit
import WebKit

final class WebViewController: BaseMainController<WebMainView>, InjectableViaFunc {
    typealias Dependencies = WebViewModel

    // MARK: - Private Properties

    private var viewModel: WebViewModel?
    
    // MARK: - InjectableViaFunc

    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input?.onViewWillAppear()
    }
}

// MARK: - Private

extension WebViewController {
    private func setupOutput() {
        viewModel?.output = .init(
            urlFetched: .init { [weak self] in
                guard let url = URL(string: $0) else { return }
                self?.mainView.webView.load(URLRequest(url: url))
            }
        )
    }
}
