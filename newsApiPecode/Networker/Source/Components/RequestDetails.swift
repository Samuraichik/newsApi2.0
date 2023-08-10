//
//  RequestDetails.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public protocol RequestDetails {
    var httpMethod: HTTPMethod { get }
    var urlComponent: URLComponents { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    var path: String { get }
    var url: String { get }
}

public extension RequestDetails {
    var urlComponent: URLComponents {
        URLComponents(string: url + path)!
    }
}
