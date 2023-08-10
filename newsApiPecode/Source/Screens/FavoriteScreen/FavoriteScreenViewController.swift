//
//  FavoritesViewController.swift
//  Neom
//
//  Created by Oleksiy Humenyuk Eventyr on 08.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class FavoritesViewController: BaseMainController<FavoritesMainView>, InjectableViaFunc {
    
    typealias Dependencies = FavoritesViewModel
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Private Properties
    
    private var viewModel: FavoritesViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupView()
    }
    
    private func setupView() {
        mainView.favoritesTableView.delegate = self
        mainView.favoritesTableView.dataSource = self
        view.backgroundColor = .clear
    }
    
    private func setupOutput() {
        viewModel?.output = .init(
            favoritesFetched: .init { [weak self] in
                self?.mainView.favoritesTableView.reloadData()
                self?.mainView.layer.layoutIfNeeded()
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input?.onViewWillAppear()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = viewModel,
              let favoritesCount = model.favorites?.count
        else { return 0 }
        
        return favoritesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTableViewCell.reuseIdentifier, for: indexPath) as? ArticlesTableViewCell,
              let favorites = viewModel?.favorites
        else { return UITableViewCell() }
        
        let article = favorites[indexPath.row]
        
        return configureFavoritesCell(cell, article: article)
    }
    
    private func configureFavoritesCell(_ cell: ArticlesTableViewCell, article: FavoriteArticle) -> UITableViewCell {
        cell.cellTitle.text = article.title
        cell.cellDescription.text = article.description
        cell.authorName.text = article.author
        cell.source.text = article.source ?? ""
        
        guard let imageUrl = article.urlToImage,
              let model = viewModel else { return cell }
        
        let image = model.checkForFavorite(article: article) ? UIImage(named: "favoritePicked") : UIImage(named: "unfavorite")
        cell.favoriteButton.setImage(image, for: .normal)
        cell.cellImage.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "placeholderImage")
        )
        
        cell.favouriteButtonAction = { [weak self] in
            self?.favoriteButtonTappedInCell(cell: cell, article: article, model: model)
        }
        
        return cell
    }
    
    private func favoriteButtonTappedInCell(cell: ArticlesTableViewCell, article: FavoriteArticle, model: FavoritesViewModel) {
        model.input?.articleTapped(article)
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
