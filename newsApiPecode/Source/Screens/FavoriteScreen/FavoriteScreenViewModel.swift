//
//  FavoritesViewModel.swift
//  Neom
//
//  Created by Oleksiy Humenyuk on 08.08.2023.
//

import UIKit
import RealmSwift

// MARK: - AnyMarketCoordinator

enum FavoritesCoordinatorEvent {
    case onClose(view: UIViewController?)
}

protocol AnyFavoritesCoordinator {
    func handle(event: FavoritesCoordinatorEvent)
}

// MARK: - AnyMarketViewModel Output & Input

struct FavoritesVMOutput: AnyOutput {
    @MainVoidThreadExecutable var favoritesFetched: VoidClosure
}

struct FavoritesVMInput: AnyInput {
    let onViewWillAppear: VoidClosure
    let articleTapped: EventHandler<FavoriteArticle>
}

protocol AnyFavoritesViewModel: AnyViewModel where Input == FavoritesVMInput, Output == FavoritesVMOutput {
    var favorites: Results<FavoriteArticle>? { get }
    
    func checkForFavorite(article: FavoriteArticle) -> Bool
}

// MARK: - MarketViewModel

final class FavoritesViewModel: InjectableViaInit, AnyFavoritesViewModel {
    
    typealias Dependencies = (AnyFavoritesCoordinator, AnyFavouriteService)
    
    private(set) var input: FavoritesVMInput?
    var output: FavoritesVMOutput?
    
    private(set) var favorites: Results<FavoriteArticle>?
    
    // MARK: - Private Properties
    
    private var pagination = Pagination(limit: 20)
    private let coordinator: AnyFavoritesCoordinator
    
    private let favoriteService: AnyFavouriteService
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator, favoriteService) = dependencies
        setupInput()
    }
    
    // MARK: - Public Functions
    
    func checkForFavorite(article: FavoriteArticle) -> Bool {
        return favoriteService.isArticleFavorite(title: article.title)
    }
    
    // MARK: - Private Functions
    
    private func setupInput() {
        input = .init(
            onViewWillAppear: { [weak self] in
                self?.fetchFavorites()
            },
            articleTapped: { [weak self] in
                self?.favoriteService.articleDidTapped(favorite: $0)
                self?.fetchFavorites()
            }
        )
    }
    
    private func fetchFavorites() {
        favorites = favoriteService.getAllObjects(ofType: FavoriteArticle.self)
        output?.favoritesFetched()
    }
}
