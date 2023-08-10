//
//  Pagination.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public struct Pagination: AnyModel {

    // MARK: - Properties

    public var limit: Int
    public private(set) var offset: Int
    public private(set) var count: Int

    public init(limit: Int = 10, offset: Int = .zero, count: Int = .zero) {
        self.limit = limit
        self.offset = offset
        self.count = count
    }

    public mutating func update(offset: Int, count: Int) {
        self.offset = offset
        self.count = count
    }
}

public extension Pagination {
    var hasMore: Bool {
        offset < count
    }
}
