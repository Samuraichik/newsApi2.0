//
//  HTTPClient.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk on 21.11.2022.
//

import Foundation

public protocol AnyHTTPClient {
    func execute<T: AnyModel>(type: T.Type, with request: RequestConvertable) async -> Result<T, Error>
}

final public class HTTPClient: AnyHTTPClient {
    
    // MARK: - Private Properties
    
    private let urlSession: URLSession
    
    // MARK: - Init
    
    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - Methods
    
    public func execute<T: AnyModel>(type: T.Type, with request: RequestConvertable) async -> Result<T, Error>  {
        return await fetchRequest(type: type, with: request.request)
    }
    
    private func fetchRequest<T: AnyModel>(type: T.Type, with request: URLRequest) async -> Result<T, Error> {
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("🔴🔴🔴 Failure: \(String(describing: (response as? HTTPURLResponse)?.statusCode)), \(request.url?.absoluteString ?? "")")
                throw InternalErrorCode.requestFailed
            }
            
            guard HTTPStatusCode(rawValue: httpResponse.statusCode) == .ok else {
                print("🔴🔴🔴 Failure: \(httpResponse.statusCode), \(request.url?.absoluteString ?? "")")
                
                throw "🔴🔴🔴 JSON Conversion Failure -> status code \(httpResponse.statusCode), \(request.url?.absoluteString ?? "")"
            }
            
            let instance = try T.init(data: data)
            
            print("✅✅✅ Success: \(httpResponse.statusCode), \(request.url?.absoluteString ?? "")")
            
            return .success(instance)
        } catch {
            return .failure(error)
        }
    }
}
