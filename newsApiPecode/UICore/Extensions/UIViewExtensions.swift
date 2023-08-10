//
//  UIViewExtensions.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation
import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
