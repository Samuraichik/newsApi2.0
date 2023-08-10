//
//  ArticlesViewModel.swift
//  Neom
//
//  Created by Oleksiy Humenyuk on 08.08.2023.
//

import UIKit


// MARK: - AnyMarketCoordinator

enum ArticlesCoordinatorEvent {
    case onTapOnCell(url: String, view: UIViewController?)
    case onTapFilters(view: UIViewController?)
}

protocol AnyArticlesCoordinator {
    func handle(event: ArticlesCoordinatorEvent)
}

// MARK: - AnyMarketViewModel Output & Input

struct ArticlesVMOutput: AnyOutput {
    @MainVoidThreadExecutable var articlesFetched: VoidClosure
    @MainVoidThreadExecutable var asyncActionDidStart: VoidClosure
    @MainVoidThreadExecutable var asyncActionDidEnd: VoidClosure
}

struct ArticlesVMInput: AnyInput {
    let onTapCell: EventHandler<(UIViewController?, Int)>
    let articleTapped: EventHandler<Article>
    let onWillDisplayItemIndex: EventHandler<Int>
    let onArticlesNeedsToBeFetched: VoidClosure
    let searchButtonPressed: EventHandler<String>
    let filtersButtonPressed: EventHandler<UIViewController?>
}

protocol AnyArticlesViewModel: AnyViewModel where Input == ArticlesVMInput, Output == ArticlesVMOutput {
    var articles: [Article] { get }
    var needToBeSorted: Bool { get set }
    
    func checkForFavorite(article: Article) -> Bool
}

// MARK: - MarketViewModel

final class ArticlesViewModel: InjectableViaInit, AnyArticlesViewModel {
    
    typealias Dependencies = (
        AnyArticlesCoordinator,
        AnyArticlesService,
        DateFormatter,
        AnyFavouriteService,
        NotificationCenter
    )
    
    private(set) var input: ArticlesVMInput?
    var output: ArticlesVMOutput?
    private(set) var articles: [Article] = []
    
    var needToBeSorted: Bool = false
    
    // MARK: - Private Properties
    
    private var pagination = Pagination(limit: 20)
    private let coordinator: AnyArticlesCoordinator
    
    private let articlesService: AnyArticlesService
    private let formatter: DateFormatter
    private let favoriteService: AnyFavouriteService
    private let notificationCenter: NotificationCenter
    private var queryParams: [QueryParameter] = []
    private var isFilters: Bool = false
    
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator,
         articlesService,
         formatter,
         favoriteService,
         notificationCenter
        ) = dependencies
        
        setupInput()
        notificationCenter.addObserver(
            self,
            selector: #selector(handleDataReceived(_:)),
            name: Notification.Name(.filtersSet),
            object: nil
        )
    }
    
    // MARK: - Public Functions
    
    func checkForFavorite(article: Article) -> Bool {
        return favoriteService.isArticleFavorite(title: article.title)
    }
    
    // MARK: - Private Functions
    
    @objc private func handleDataReceived(_ notification: Notification) {
        queryParams.removeAll()
        if let data = notification.object as? FilterParameters {
            if let source = data.source  {
                queryParams.append(QueryParameter(key: "sources", value: source))
            }
            
            if let country = data.country{
                queryParams.append(QueryParameter(key: "country", value: country))
            }
            
            if let category = data.category {
                queryParams.append(QueryParameter(key: "category", value: category))
            }
        }
    }
    
    private func articleTapped(article: Article) {
        let favoriteArticle: FavoriteArticle = .init(article: article)
        return favoriteService.articleDidTapped(favorite: favoriteArticle)
    }
    
    private func setupInput() {
        input = .init(
            onTapCell: { [weak self] in
                guard let url = self?.articles[safe: $0.1]?.url else { return }
                self?.coordinator.handle(event: .onTapOnCell(url: url, view: $0.0))
            },
            articleTapped: { [weak self] in
                self?.articleTapped(article: $0)
            },
            onWillDisplayItemIndex: { [weak self] index in
                self?.fetchMoreArticlesIfNeeded(after: index)
            },
            onArticlesNeedsToBeFetched: { [weak self] in
                self?.fetchArticles()
            },
            searchButtonPressed: { [weak self] in
                self?.clearParams(searchValue: $0)
            },
            filtersButtonPressed:  { [weak self] in
                self?.coordinator.handle(event: .onTapFilters(view: $0))
            }
        )
    }
    
    private func fetchArticles(reset: Bool = true) {
        if reset {
            articles.removeAll()
            pagination = Pagination(limit: 10)
        }
        output?.asyncActionDidStart()
        Task {
            switch await articlesService.fetchArticles(
                params: queryParams,
                isFilters: isFilters,
                pagination: pagination
            ) {
            case .success(let data):
                self.appendArticles(data: data)
                
                self.pagination.update(offset: self.articles.count, count: data.totalResults ?? 10)
                self.output?.articlesFetched()
            case .failure(let error):
                print("ERROR IS \(error)")
            }
            output?.asyncActionDidEnd()
        }
    }
    
    private func appendArticles(data: Articles) {
        self.articles += needToBeSorted ? data.articles.suffix(pagination.limit).sorted { article1, article2 in
            guard let date1 = formatter.date(from: article1.publishedAt!),
                  let date2 = formatter.date(from: article2.publishedAt!)
            else {
                return false
            }
            return date1 < date2
        } : data.articles.suffix(pagination.limit)
    }
    
    private func clearParams(searchValue: String) {
        self.queryParams.removeAll()
        if searchValue != "" {
            self.queryParams.append(QueryParameter(key: "q", value: searchValue))
        }
        self.articles.removeAll()
        self.fetchArticles()
    }
    
    private func fetchMoreArticlesIfNeeded(after index: Int) {
        guard pagination.hasMore, (articles.count - 1 == index) else { return }
        
        fetchArticles(reset: false)
    }
}
