//
//  AnyServiceResolverOwner.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.11.2022.
//

import Swinject

protocol AnyServiceResolverOwner: AnyResolverOwner {
    var network: AnyHTTPClient { get }
    var articlesService: any AnyArticlesService { get }
    var favoriteService: any AnyFavouriteService { get }
}

extension AnyServiceResolverOwner {
    var network: AnyHTTPClient { resolver.resolve() }
    var articlesService: any AnyArticlesService { resolver.resolve() }
    var favoriteService: any AnyFavouriteService { resolver.resolve() }
}
