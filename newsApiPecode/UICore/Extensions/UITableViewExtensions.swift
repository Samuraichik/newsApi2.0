//
//  UITableViewExtensions.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation
import UIKit

public extension UITableView {
    @discardableResult
    final func register<T: UITableViewCell>(cellType: T.Type) -> Self where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
        return self
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T? where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            return nil
        }
        
        return cell
    }
    
    func deselectAllRows(animated: Bool = true) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        
        for indexPath in selectedRows {
            deselectRow(at: indexPath, animated: animated)
        }
    }
}
