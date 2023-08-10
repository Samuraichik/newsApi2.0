//
//  MarketMainView.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import WebKit

final class WebMainView: BaseInteractiveView {

    // MARK: - Private Properties

    var webView: WKWebView = WKWebView()

    // MARK: - Lifecycle

    override func addViews() {
        addSubview(webView)
    }

    override func anchorViews() {
        webView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
