//
//  SystemAssembly.swift
//  Takoha
//
//  Created by Oleksiy Humenyuk Eventyr on 21.11.2022.
//

import Swinject
import UIKit

final class SystemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UIApplication.self) { _ in
            UIApplication.shared
        }.inObjectScope(.container)

        container.register(AppDelegate.self) { resolver in
            let application = resolver.resolve(UIApplication.self)!
            return application.delegate as! AppDelegate
        }.inObjectScope(.container)

        container.register(SceneDelegate.self) { resolver in
            let application = resolver.resolve(UIApplication.self)!
            return application.connectedScenes.first!.delegate as! SceneDelegate
        }.inObjectScope(.container)

        container.register(UIWindow.self) { resolver in
            let sceneDelegate = resolver.resolve(SceneDelegate.self)!
            return sceneDelegate.window!
        }

        container.register(ResolverOwner.self) { resolver in
                .init(dependencies: resolver)
        }
        
        container.register(DateFormatter.self) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return dateFormatter
        }
    }
}
