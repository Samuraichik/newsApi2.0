//
//  ServicesAssembly.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.11.2022.
//

import Swinject
import Foundation
import Realm
import RealmSwift

final class ServicesAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(URLSessionConfiguration.self) { _ in
            URLSessionConfiguration.default
        }
        
        container.register(URLSession.self) { resolver in
            URLSession(configuration: resolver.resolve(URLSessionConfiguration.self)!)
        }
        
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }.inObjectScope(.container)
        
        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }.inObjectScope(.container)
        
        container.register(AnyHTTPClient.self) { resolver in
            let client = HTTPClient(
                urlSession: resolver.resolve(URLSession.self)!
            )

            return client
        }.inObjectScope(.container)
        
        container.register((any AnyFavouriteService).self) { resolver in
            FavouriteService(dependencies: resolver.resolve()!)
        }.inObjectScope(.container)
        
        
        container.register((any AnyArticlesService).self) { resolver in
            ArticlesService(dependencies: (
                resolver.resolve(AnyHTTPClient.self)!
            ))
        }.inObjectScope(.container)
        
        container.register(Realm.Configuration.self) { _ in
           Realm.Configuration(
                schemaVersion: 4,
                deleteRealmIfMigrationNeeded: true
            )
        }
        
        container.register(Realm.self) { resolver in
            try! Realm(configuration: resolver.resolve()!)
        }
    }
}
