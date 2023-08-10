//
//  Articles.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

struct Articles: AnyModel {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}
