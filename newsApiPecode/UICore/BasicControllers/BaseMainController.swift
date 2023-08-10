//
//  BaseMainController.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import SnapKit
import UIKit

open class BaseMainController<View: BaseInteractiveView>: UIViewController,
                                                          UIViewControllerTransitioningDelegate,
                                                          AnyBaseControllerLifecycle {

    // MARK: - Private Properties

    private(set) var wasShownAtLeastOnce = false

    // MARK: - Public Properties

    open var isNeedToHideNavBarOnDismiss = false
    open var mainView: View
    open var isNavigationBarHidden: Bool = false

    // MARK: - Inits

    public init(view: View = View()) {
        self.mainView = view
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("required init not implemented")
    }

    // MARK: - Life Cycle

    open override func loadView() {
        super.loadView()
        mainView.frame = view.frame
        view = mainView
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)

        if wasShownAtLeastOnce {
            viewWillAppearAgain()
        } else {
            viewWillAppearAtFirstTime()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if wasShownAtLeastOnce {
            viewDidAppearAgain()
        } else {
            viewDidAppearAtFirstTime()
        }

        wasShownAtLeastOnce = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isNeedToHideNavBarOnDismiss {
            navigationController?.setNavigationBarHidden(true, animated: true)
            isNeedToHideNavBarOnDismiss = false
        }
    }

    // MARK: - Public Methods

    open func viewWillAppearAtFirstTime() {
        // to override
        configureUI()
        configureActions()
    }

    // MARK: - Private Methods

    open func setupKeyboardGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: - Show Error Methods

    open func showError(_ error: Error, with duration: TimeInterval? = 3.0) {
        // to fill later
    }

    open func showSuccessAlert(_ message: String, with duration: TimeInterval? = 3.0) {
        // to fill later
    }

    // MARK: - Actions

    @objc private func endEditing() {
        view.endEditing(true)
    }
}
