//
//  ViewOutputProvider.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - ViewOutputProvider

protocol ViewOutputProvider {

    /// Module input for the current object
    var viewOutput: ModuleInput? { get }
}
