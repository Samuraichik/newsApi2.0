//
//  HTTPMethod.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public enum HTTPMethod: String {
    case get        = "GET"
    case put        = "PUT"
    case post       = "POST"
    case delete     = "DELETE"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case trace      = "TRACE"
    case connect    = "CONNECT"
}
