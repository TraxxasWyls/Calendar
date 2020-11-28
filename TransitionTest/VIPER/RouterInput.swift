//
//  RouterInput.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import UIKit

// MARK: - RouterInput

protocol RouterInput {

    /// Transition handler instance
    var transitionHandler: TransitionHandler { get }

    /// Close current module
    func close(animated: Bool)

    /// Close current module
    func close()
}

// MARK: - TransitionHandler

extension RouterInput {

    func showShareDialog(withItem item: Any) {
        transitionHandler.showShareDialog(withItem: item)
    }

    func close(animated: Bool) {
        transitionHandler
            .closeCurrentModule()
            .animate(animated)
            .perform()
    }

    func close() {
        close(animated: true)
    }
}
