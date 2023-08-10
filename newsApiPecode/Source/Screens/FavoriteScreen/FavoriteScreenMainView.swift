//
//  FavoritesView.swift
//  Neom
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import SnapKit
import UIKit

final class FavoritesMainView: BaseInteractiveView {
    
    // MARK: - Public Properties
    
    let favoritesTableView: UITableView = {
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.separatorStyle = .none
        $0.contentInset = .zero
        $0.showsVerticalScrollIndicator = false
        $0.register(
            UINib(nibName: ArticlesTableViewCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: ArticlesTableViewCell.reuseIdentifier
        )
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    // MARK: - Lifecycle
    
    override func addViews() {
        addSubviews([favoritesTableView])
    }
    
    override func anchorViews() {
        inactiveConstraints.append(contentsOf: makeTableViewViewConstraints())
    }
    
    override func configureViews() {
        backgroundColor = .white
    }
    
    // MARK: - Helper Methods
    
    private func makeTableViewViewConstraints() -> [Constraint] {
        favoritesTableView.snp.prepareConstraints {
            $0.top.left.right.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

