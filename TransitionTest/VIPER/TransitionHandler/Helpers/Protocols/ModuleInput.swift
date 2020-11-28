//
//  ModuleInput.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - ModuleInput

protocol ModuleInput: class {

    /// Set module output for the current module
    ///
    /// - Parameter moduleOutput: ModuleOutput instance
    func setModuleOutput(_ moduleOutput: ModuleOutput)
}

extension ModuleInput {

    func setModuleOutput(_ moduleOutput: ModuleOutput) {
    }
}
