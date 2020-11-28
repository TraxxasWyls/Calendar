//
//  CloseCurrentModuleStyle.swift
//  TransitionHandler
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2019 incetro. All rights reserved.
//

import UIKit

// MARK: - CloseTransitionStyle

/// Shows how we should close some controller
enum CloseTransitionStyle {

    /// Auxililary enum for the `navigation` style
    enum NavigationControllerStyle {

        /// Pop action to the given controller
        case pop(to: UIViewController)

        /// Replace last controller on the given controller
        /// with pop animation
        case forcePop(to: UIViewController)

        /// Simple pop on a previous controller
        case simplePop

        /// Pop to the root controller
        case toRoot

        /// Pop to the controller that satisfies the condition
        /// in the `condition(pop:)` method
        case conditionPop
    }

    /// Make custom navigation controller close action.
    case navigation(style: NavigationControllerStyle)

    /// Default style (from presenting or parent)
    case `default`
}
