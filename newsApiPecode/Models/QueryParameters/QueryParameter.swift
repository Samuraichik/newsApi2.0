//
//  QueryParameter.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

struct QueryParameter {
    var key: String
    var value: String
    var stringRepresentation: String {
        return key + "=" + value
    }
}
