//
//  ArticlesRequest.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

enum ArticlesRequest: RequestDetails, RequestConvertable {
    case fetchArticles(params: [QueryParameter], isFilters: Bool, pagination: Pagination)
    
    //MARK: - Properties
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchArticles:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchArticles:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .fetchArticles(let params, let isFilters, let pagination):
            return buildUrl(params: params, isFilters: isFilters, pagination: pagination)
        }
    }
    
    var url: String {
        return "https://newsapi.org/v2/"
    }
    
    var headers: [String: String] {
        let headers: [String: String] = [:]
        return headers
    }
    
    var isNeededToken: Bool {
        true
    }
    
    func buildUrl(params: [QueryParameter], isFilters: Bool, pagination: Pagination) -> String {
        guard let apiKey = UserDefaults.standard.string(forKey: .apiKey) else { return  "" }
        
        var baseUrl = ""
  
        if params.isEmpty {
            baseUrl = "everything?q=world&apiKey=\(apiKey)"
            let paginationLimit = pagination.offset + 10
            baseUrl += "&pageSize=\(paginationLimit)"
        } else {
            baseUrl = "top-headlines?"
    
            for value in params {
                baseUrl += "\(value.stringRepresentation)&"
            }
        
            baseUrl += "apiKey=\(apiKey)"
        }
   
        return baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
