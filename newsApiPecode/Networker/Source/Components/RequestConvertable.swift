//
//  Request.swift
//  Network
//
//  Created by oleksiy humenyuk  on 27.09.2022.
//

import Foundation

public protocol RequestConvertable {
    var request: URLRequest { get }
    var isNeededToken: Bool { get }
}

public extension RequestConvertable where Self: RequestDetails {
    var request: URLRequest {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}
