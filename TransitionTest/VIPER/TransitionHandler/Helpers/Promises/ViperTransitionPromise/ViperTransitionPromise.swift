//
//  ViperTransitionPromise.swift
//  TransitionHandler
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2019 incetro. All rights reserved.
//

import UIKit

// MARK: - ViperTransitionPromise

final class ViperTransitionPromise<T>: TransitionPromise<T> {

    /// NavigationController for destnation which is used
    /// when you need to set a different controller
    private var navigationController: UINavigationController?

    var isAnimated: Bool {
        animated
    }

    // swiftlint:disable cyclomatic_complexity

    /// Configures the current promise with the specific `transition` style
    ///
    /// This method allows you to use the `TransitionStyle` auxiliary enum to set the transition type
    /// for your promise if default  presentation style isn't what do you want
    ///
    /// - Returns: Current promise
    func to(_ style: TransitionStyle) -> ViperTransitionPromise<T> {
        promise = nil
        promise { [weak self] in
            guard let destination = self?.destination else {
                throw TransitionHandlerError.nilController("Destination")
            }
            guard let source = self?.source, let animated = self?.isAnimated else {
                throw TransitionHandlerError.nilController("Source")
            }
            switch style {
            case .navigation(style: let navStyle):
                guard let navController = source.navigationController else {
                    throw TransitionHandlerError.nilController("Transition error, navigation")
                }
                switch navStyle {
                case .pop:
                    navController.popToViewController(destination, animated: animated)
                case .present:
                    navController.present(destination, animated: animated, completion: nil)
                case .push:
                    navController.pushViewController(destination, animated: animated)
                case .replace(let style):
                    switch style {
                    case .all:
                        navController.setViewControllers([destination], animated: animated)
                    case .last:
                        let controllers = Array(navController.children.dropLast())
                        navController.setViewControllers(controllers + [destination], animated: animated)
                    }
                }
            case .split(style: let splitStyle):
                guard let splitController = source.splitViewController else {
                    throw TransitionHandlerError.nilController("Transition error, navigation")
                }
                switch splitStyle {
                case .detail:
                    splitController.show(destination, sender: nil)
                case .default:
                    splitController.showDetailViewController(destination, sender: nil)
                }
            case let .modal(transition, presentation):
                destination.modalTransitionStyle = transition
                destination.modalPresentationStyle = presentation
                source.present(destination, animated: animated, completion: nil)
            case .present:
                let controller: UIViewController
                if let navigationController = self?.navigationController {
                    navigationController.modalPresentationStyle = destination.modalPresentationStyle
                    navigationController.setViewControllers([destination], animated: false)
                    controller = navigationController
                } else {
                    controller = destination
                }
                source.present(controller, animated: animated, completion: nil)
            }
        }
        return self
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length

    /// Set destination navigationController for promise
    ///
    /// - Parameter navigationController: navigationController for destionation
    /// - Returns: P
    func set(navigationController: UINavigationController) -> ViperTransitionPromise<T> {
        self.navigationController = navigationController
        return self
    }

    /// Set transitioningDelegate for destination in promise
    ///
    /// - Parameter transitioningDelegate: delegate for destination
    /// - Returns: Current promise
    func set(transitioningDelegate: UIViewControllerTransitioningDelegate) -> ViperTransitionPromise<T> {
        self.destination?.transitioningDelegate = transitioningDelegate
        return self
    }

    /// Gives you basic template to create custom transition
    ///
    /// - Returns: Custom Promise with setups
    func customTransition() -> CustomTransitionPromise<T> {
        let destination = self.destination.unwrap(TransitionHandlerError.nilController("Destination"))
        promise = nil
        return CustomTransitionPromise(source: source, destination: destination, for: type)
    }
}
