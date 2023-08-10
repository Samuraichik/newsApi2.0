//
//  AnyArticlesRepository.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

protocol AnyArticlesService: AnyObject  {
    func fetchArticles(params: [QueryParameter], isFilters: Bool, pagination: Pagination) async -> Result<Articles, Error>
}

final class ArticlesService: AnyArticlesService, InjectableViaInit {
    typealias Dependencies = AnyHTTPClient
    
    // MARK: - Private Properties
    
    private let httpClient: AnyHTTPClient
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        httpClient = dependencies
    }
    
    // MARK: - Methods
    
    func fetchArticles(params: [QueryParameter], isFilters: Bool, pagination: Pagination) async -> Result<Articles, Error> {
        do {
            let data = try await httpClient.execute(
                type: Articles.self,
                with: ArticlesRequest.fetchArticles(
                    params: params,
                    isFilters: isFilters,
                    pagination: pagination
                )
            ).get()
            
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
