//
//  AnyOutput.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import Foundation

public protocol AnyOutput {}
public protocol AnyInput {}

public protocol AnyViewModel: AnyObject {
    associatedtype Input where Input: AnyInput
    associatedtype Output where Output: AnyOutput

    var input: Input? { get }
    var output: Output? { get set }
}
