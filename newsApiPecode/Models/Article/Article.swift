//
//  Article.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

struct Article: AnyModel {
    let author: String?
    let description: String?
    let content: String?
    let publishedAt: String?
    let source: Source
    let title: String
    let url: String
    let urlToImage: String?
}
