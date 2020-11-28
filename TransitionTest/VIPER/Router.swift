//
//  Router.swift
//  TheRun
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import UIKit

// MARK: - Router

class Router: RouterInput {

    // MARK: - Properties

    /// Transition handler instance
    private(set) unowned var transitionHandler: TransitionHandler

    // MARK: - Initializers

    /// Default initializer
    ///
    /// - Parameter transitionHandler: transition handler instance
    init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
}

// MARK: - SettingsRevealableRouterInput

protocol SettingsRevealableRouterInput {

    /// Open app settings
    func openSettings()
}

// MARK: - SettingsRevealableRouter

class SettingsRevealableRouter: Router {

    /// UIApplication instance
    let application: UIApplication

    /// Bundle instance
    let bundle: Bundle

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - transitionHandler: transition handler instance
    ///   - application: UIApplication instance
    ///   - bundle: Bundle instance
    init(
        transitionHandler: TransitionHandler,
        application: UIApplication,
        bundle: Bundle
    ) {
        self.application = application
        self.bundle = bundle
        super.init(transitionHandler: transitionHandler)
    }

    // MARK: - SettingsRevealableRouterInput

    final func openSettings() {
        guard
            let bundleIdentifier = bundle.bundleIdentifier,
            let settingsUrl = URL(string: UIApplication.openSettingsURLString + bundleIdentifier)
        else { return }
        application.open(settingsUrl)
    }
}
