//
//  FavoriteService.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 09.08.2023.
//

import UIKit
import RealmSwift

protocol AnyFavouriteService: AnyObject {
    func isArticleFavorite(title: String) -> Bool
    func articleDidTapped(favorite: FavoriteArticle)
    func getAllObjects<T: Object>(ofType type: T.Type) -> Results<T>?
}

final class FavouriteService: AnyFavouriteService, InjectableViaInit {
    typealias Dependencies = Realm
    
    private var realm: Realm
    
    // MARK: - Init
    
    required init(dependencies: Dependencies) {
        realm = dependencies
    }

    func isArticleFavorite(title: String) -> Bool {
        return realm.objects(FavoriteArticle.self).filter("title == %@", title).count > 0 ?  true : false
    }
    
    func articleDidTapped(favorite: FavoriteArticle) {
        try! realm.write {
            if isArticleFavorite(title: favorite.title) {
                if let objectToDelete = realm.objects(FavoriteArticle.self).filter("title == %@", favorite.title).first {
                    realm.delete(objectToDelete)
                }
            } else {
                realm.add(favorite)
            }
            realm.refresh()
        }
    }
    
    func getAllObjects<T: Object>(ofType type: T.Type) -> Results<T>? {
        let realm = try? Realm()
        return realm?.objects(type)
    }
    
}
