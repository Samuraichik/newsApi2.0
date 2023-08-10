//
//  ArticlesViewController.swift
//  Neom
//
//  Created by Oleksiy Humenyuk Eventyr on 08.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class ArticlesViewController: BaseMainController<ArticlesMainView>, InjectableViaFunc {
    typealias Dependencies = ArticlesViewModel
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Private Properties
    
    private var viewModel: ArticlesViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutput()
        setupView()
        addTargets()
        setupNavBar()
    }
    
    @objc private func filtersButtonPressed(_ sender: UIButton) {
        viewModel?.input?.filtersButtonPressed(self)
    }
    
    private func setupView() {
        mainView.articlesTableView.delegate = self
        mainView.articlesTableView.dataSource = self
        view.backgroundColor = .clear
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Filters",
            image: nil,
            target: self,
            action: #selector(filtersButtonPressed)
        )
        
        navigationController?.applyDefaultNavBarAppearance()
    }
    
    private func addTargets() {
        mainView.refreshControl.addEventHandler(for: .valueChanged) { [weak self] _ in
            self?.viewModel?.input?.onArticlesNeedsToBeFetched()
        }
        
        mainView.sortSegmentControl.addEventHandler(for: .valueChanged) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.needToBeSorted = mainView.sortSegmentControl.selectedSegmentIndex == 0 ? true : false
        }

        mainView.searchButton.addEventHandler(for: .touchUpInside) { [weak self] _ in
            guard let text = self?.mainView.searchField.text else { return }
            self?.viewModel?.input?.searchButtonPressed(text)
        }
    }
    
    private func setupOutput() {
        viewModel?.output = .init(
            articlesFetched: .init { [weak self] in
                self?.mainView.articlesTableView.reloadData()
            },
            asyncActionDidStart: .init { [weak self] in
                guard let self = self else { return }
                
                self.mainView.articlesTableView.tableFooterView = self.createLoaderFooter()
            },
            asyncActionDidEnd: .init { [weak self] in
                guard let self = self else { return }
                self.mainView.refreshControl.endRefreshing()
                self.mainView.articlesTableView.tableFooterView = nil
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input?.onArticlesNeedsToBeFetched()
    }
}

// MARK: - UITableViewDataSource

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = viewModel else { return 0 }
        return model.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articlesHistorCell = tableView.dequeueReusableCell(
            withIdentifier: ArticlesTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ArticlesTableViewCell,
              let model = viewModel
        else { return UITableViewCell() }
        
        guard let article = model.articles[safe: indexPath.item] else { return articlesHistorCell }
        return configureArticlesCell(articlesHistorCell, article: article)
    }
    
    func createLoaderFooter() -> UIView {
        let footerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.size.width,
                height: 100
            )
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func configureArticlesCell(_ cell: ArticlesTableViewCell, article: Article) -> UITableViewCell {
        cell.cellTitle.text = article.title
        cell.cellDescription.text = article.description
        cell.authorName.text = article.author
        cell.source.text = article.source.name
        
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
    
    private func favoriteButtonTappedInCell(cell: ArticlesTableViewCell, article: Article, model: ArticlesViewModel) {
        model.input?.articleTapped(article)
        let image = model.checkForFavorite(article: article) ? UIImage(named: "favoritePicked") : UIImage(named: "unfavorite")
        cell.favoriteButton.setImage(image, for: .normal)
    }
}

// MARK: - UITableViewDelegate

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.input?.onTapCell((self, indexPath.row))
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.input?.onWillDisplayItemIndex(indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}
