//
//  AnyResolverOwner.swift
//  Neom
//
//  Created by ruras on 27.09.2022.
//  Copyright © 2022 V-eCommerce. All rights reserved.
//

import Swinject

// MARK: - AnyResolverOwner

protocol AnyResolverOwner {
    var resolver: Resolver { get }
}
