//
//  MainTabBarViewController.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

import UIKit

final class MainTabBarViewController: UITabBarController, InjectableViaFunc {
    typealias Dependencies = MainTabBarViewModel
    
    // MARK: - Public Properties
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
      .portrait
    }
    
    // MARK: - Private Properties

    private var viewModel: MainTabBarViewModel?

    // MARK: - Injectable

    func inject(dependencies: Dependencies) {
        viewModel = dependencies
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.backgroundColor = .white

        setupTabBar()
    }

    private func setupTabBar() {
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .gray

        tabBarAppearance.shadowColor = nil
        tabBarAppearance.shadowImage = nil

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        tabBar.tintColor = .white
        tabBar.itemPositioning = .centered
    }
}
