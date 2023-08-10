//
//  FiltersViewController.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import UIKit

final class FiltersViewController: BaseMainController<FiltersMainView>, InjectableViaFunc {
    typealias Dependencies = FiltersViewModel
    
    // MARK: - Private Properties
    
    private var viewModel: FiltersViewModel?
    
    // MARK: - InjectableViaFunc
    
    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        setupNavBar()
        view.backgroundColor = .lightGray
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Accept",
            image: nil,
            target: self,
            action: #selector(acceptButtonPressed)
        )
    }
    
    private func addTargets() {
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
        mainView.segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
    }
    
    @objc private func acceptButtonPressed(_ sender: UIButton) {
        viewModel?.input?.acceptButtonDidTap(self)
    }
    
    @objc private func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel?.setPickerState(state: .category)
            mainView.pickerView.reloadAllComponents()
        case 1:
            viewModel?.setPickerState(state: .country)
            mainView.pickerView.reloadAllComponents()
        case 2:
            viewModel?.setPickerState(state: .source)
            mainView.pickerView.reloadAllComponents()
        default:
            break
        }
    }
}

extension FiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let model = viewModel else { return 0 }
        return model.getFiltersCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.getPickerState(row: row)
    }
}
