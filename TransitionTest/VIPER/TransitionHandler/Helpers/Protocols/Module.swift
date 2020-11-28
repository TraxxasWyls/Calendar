//
//  Module.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit

// MARK: - Module

protocol Module {

    /// Current module's view type
    associatedtype View

    /// ModuleInput type
    associatedtype Input

    /// Instantiate module as a view
    ///
    /// - Returns: new module instance
    static func instantiate() -> View
}

// MARK: - AdvancedModule

protocol AdvancedModule: Module {

    associatedtype Data

    /// Instantiate module as a view with data
    /// - Parameter data: initial module data
    static func instantiate(withData data: Data) -> View
}

extension AdvancedModule {

    static func instantiate() -> View {
        fatalError("You must use `instantiate(withData:)` method in advanced modules")
    }
}
