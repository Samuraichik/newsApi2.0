//
//  FavoriteArticle.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation
import RealmSwift

class FavoriteArticle: Object {
    @Persisted var title = ""
    @Persisted var articleDescription = ""
    @Persisted var urlToImage: String?
    @Persisted var author: String?
    @Persisted var source: String?
    @Persisted var url = ""
    
    override init() {
        super.init()
    }
    
    init(article: Article) {
        title = article.title
        articleDescription = article.description ?? ""
        urlToImage = article.urlToImage ?? ""
        author = article.author
        source = article.source.name
        url = article.url
    }
}
