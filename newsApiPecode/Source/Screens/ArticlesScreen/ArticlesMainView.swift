//
//  ArticlesView.swift
//  Neom
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import SnapKit
import UIKit

final class ArticlesMainView: BaseInteractiveView {
    
    // MARK: - Public Properties
    
    lazy var articlesTableView: UITableView = {
        $0.backgroundColor = .clear
        $0.allowsMultipleSelection = false
        $0.separatorStyle = .none
        $0.contentInset = .zero
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = refreshControl
        $0.register(
            UINib(nibName: ArticlesTableViewCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: ArticlesTableViewCell.reuseIdentifier
        )
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    lazy var sortSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Yes","No"])
        segment.selectedSegmentIndex = 1
        segment.isUserInteractionEnabled = true
        return segment
    }()
    
    lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.textColor = UIColor.black
        searchField.placeholder = "Enter"
        searchField.textAlignment = .center
        searchField.borderStyle = UITextField.BorderStyle.line
        return searchField
    }()
    
    private(set) var refreshControl: UIRefreshControl = {
        $0.tintColor = .gray
        $0.isUserInteractionEnabled = true
        return $0
    }(UIRefreshControl())
    
    // MARK: - Private Properties
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.minimumScaleFactor = 0.4
        label.text = "SortByData:"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func addViews() {
        addSubviews([
            articlesTableView,
            sortLabel,
            sortSegmentControl,
            searchField,
            searchButton
        ])
    }
    
    override func anchorViews() {
        inactiveConstraints.append(contentsOf: makeTableViewConstraints())
        inactiveConstraints.append(contentsOf: makeSearchButtonViewConstraints())
        inactiveConstraints.append(contentsOf: makeSortLabelConstraints())
        inactiveConstraints.append(contentsOf: makeTextFieldConstraints())
        inactiveConstraints.append(contentsOf: makeSortSegmentConstraints())
    }
    
    override func configureViews() {
        backgroundColor = .white
    }
    
    // MARK: - Helper Methods
    
    private func makeSearchButtonViewConstraints() -> [Constraint] {
        searchButton.snp.prepareConstraints {
            $0.top.left.equalTo(safeAreaLayoutGuide).offset(5)
            $0.height.equalTo(30)
            $0.width.equalTo(45)
        }
    }
    
    private func makeTextFieldConstraints() -> [Constraint] {
        searchField.snp.prepareConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(5)
            $0.height.equalTo(25)
            $0.width.equalTo(80)
            $0.leading.equalTo(searchButton.snp.trailing).offset(10)
        }
    }
    
    private func makeSortLabelConstraints() -> [Constraint] {
        sortLabel.snp.prepareConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(5)
            $0.height.equalTo(25)
            $0.trailing.equalTo(sortSegmentControl.snp.leading).offset(-10)
        }
    }
    
    private func makeSortSegmentConstraints() -> [Constraint] {
        sortSegmentControl.snp.prepareConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
    }
    
    private func makeTableViewConstraints() -> [Constraint] {
        articlesTableView.snp.prepareConstraints {
            $0.left.right.bottom.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(searchButton.snp.bottom).offset(20)
        }
    }
}

