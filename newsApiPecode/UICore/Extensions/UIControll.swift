//
//  UIControll.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 09.08.2023.
//

import Foundation
import UIKit

public extension UIControl {
    func addEventHandler(
        for controlEvents: UIControl.Event = .touchUpInside,
        _ closure: @escaping (Any) -> ()
    ) {
        @objc class ClosureSleeve: NSObject {
            let closure: (_ sender: Any) -> ()
            init(_ closure: @escaping (_ sender: Any) -> ()) { self.closure = closure }
            @objc func invoke(_ sender: Any) { closure(sender) }
        }

        let sleeve = ClosureSleeve(closure)

        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)

        objc_setAssociatedObject(
            self,
            "\(UUID())",
            sleeve,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        )
    }
}
