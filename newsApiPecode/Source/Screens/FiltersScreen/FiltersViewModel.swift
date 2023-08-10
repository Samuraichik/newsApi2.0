//
//  FiltersViewModel.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import UIKit

enum PickerState {
    case source
    case country
    case category
}

enum FiltersViewCoordinatorEvent {
    case onClose(view: UIViewController?)
}

protocol AnyFiltersViewCoordinator {
    func handle(event: FiltersViewCoordinatorEvent)
}

// MARK: - AnyFiltersViewViewModel Output & Input

struct FiltersViewVMOutput: AnyOutput {
    @MainThreadExecutable var urlFetched: EventHandler<String>
}

struct FiltersViewVMInput: AnyInput {
    let acceptButtonDidTap: EventHandler<UIViewController>
}

// MARK: - AnyFiltersViewViewModel

protocol AnyFiltersViewViewModel: AnyViewModel where Input == FiltersViewVMInput, Output == FiltersViewVMOutput {
    func getPickerState(row: Int) -> String
    func setPickerState(state: PickerState)
    func getFiltersCount() -> Int
}

final class FiltersViewModel: AnyFiltersViewViewModel, InjectableViaInit {
    typealias Dependencies = (AnyFiltersViewCoordinator, NotificationCenter)
    
    // MARK: - Input/Output
    
    var output: FiltersViewVMOutput?
    private(set) lazy var input: FiltersViewVMInput? = {
        .init(
            acceptButtonDidTap: { [weak self] in
                self?.acceptButtonDidTap(view: $0)
            }
        )
    }()
    
    // MARK: - Private Properties
    
    private let categories: [String] = categoriesArray
    private let country: [String] = countriesArray
    private let source: [String] = sourcesArray
    
    private let coordinator: AnyFiltersViewCoordinator
    private var currentPickerState: PickerState = .category
    private var notificationCenter: NotificationCenter
    private var selectedParameters: FilterParameters = .init()
   
    // MARK: - Init
    
    init(dependencies: Dependencies) {
        (coordinator, notificationCenter) = dependencies
        selectedParameters.category = categories[safe: 0]
        
    }
    
    private func acceptButtonDidTap(view: UIViewController) {
        notificationCenter.post(name: Notification.Name(.filtersSet), object: selectedParameters)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.coordinator.handle(event: .onClose(view: view))
        }
    }
    
    func getPickerState(row: Int) -> String {
        selectedParameters.country = nil
        selectedParameters.source = nil
        selectedParameters.category = nil
        switch currentPickerState {
        case .source:
            selectedParameters.source = source[safe: row]
            return source[row]
        case .category:
            selectedParameters.category = categories[safe: row]
            return categories[row]
        case .country:
            selectedParameters.country = country[safe: row]
            return country[row]
        }
    }
    
    func setPickerState(state: PickerState) {
        currentPickerState = state
    }
    
    func getFiltersCount() -> Int {
        switch currentPickerState {
        case .source:
            return source.count
        case .category:
            return categories.count
        case .country:
            return country.count
        }
    }
}
