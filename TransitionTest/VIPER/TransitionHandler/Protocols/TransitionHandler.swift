//
//  TransitionHandler.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit

typealias TransitionConfigureBlock<T> = (T) -> Void

// MARK: - ParentType

/// Shows how we should get parent controller
enum ParentType {

    /// `first UIViewController` in the hierarchy of `UIViewController's`
    case most

    /// `parent UIViewController` of Self controller
    case prev
}

// MARK: - TransitionHandler

protocol TransitionHandler: class {

    /// Return current module's input
    var moduleInput: ModuleInput? { get }

    /// Return current module's output
    var moduleOutput: ModuleOutput? { get }

    /// Returns parent transition handler
    ///
    /// If `type` equals to `.prev` then this method will return `parent UIViewController`
    /// else if `type` equals to `.most` then it will return `first UIViewController`
    /// in the hierarchy of `UIViewController's`
    ///
    /// - Parameter type: parent type
    func parent(_ type: ParentType) -> TransitionHandler?

    /// Transition for Module
    ///
    /// This method creates a `M.View: UIViewController` instance with help of
    /// static method of `Module` `instantiate` after that it creates `promise`
    /// which you can modify or `perform`
    /// Default `promise` will `present` controller of the`Module` with animation
    ///
    /// - Parameters:
    ///   - moduleType: whole module type
    /// - Returns: Promise with setups
    func openModule<M>(
        _ moduleType: M.Type
    ) -> ViperTransitionPromise<M.Input> where M: Module, M.View: UIViewController

    /// Transition for advanced modules
    ///
    /// Same as method above but it will `instantiate` controller with
    /// some kind of `data`
    ///
    /// - Parameters:
    ///   - moduleType: whole module type
    ///   - data: data for module initializations
    /// - Returns: Promise with setups
    func openModule<M>(
        _ moduleType: M.Type,
        withData data: M.Data
    ) -> ViperTransitionPromise<M.Input> where M: AdvancedModule, M.View: UIViewController


    /// Close current module
    ///
    /// Setups `CloseTransitionPromise` to close current `Module`in different situations:
    /// `parent` is `UINavigationController`
    /// `parent` exist but not `UINavigationController`
    /// `parent` isn't exist  and  `presentingViewController` not `nil` then ` self.dismiss`
    func closeCurrentModule() -> CloseTransitionPromise

    /// Show share menu for some item
    ///
    /// - Important: this method runs `asynchronous` in `main queue`
    /// - Parameter item: item fot sharing
    func showShareDialog(withItem item: Any)
}

extension TransitionHandler {

    var moduleOutput: ModuleOutput? {
        moduleInput as? ModuleOutput
    }
}

// MARK: - Additions

extension TransitionHandler where Self: UIViewController {

    func parent(_ type: ParentType) -> TransitionHandler? {
        switch type {
        case .prev:
            return parent
        case .most:
            let result = parent == nil ? self : parent?.parent(type)
            switch result {
            case let searchController as UISearchController:
                return searchController.presentingViewController?.parent(type)
            case let navigationController as UINavigationController:
                return navigationController.topViewController
            case let tabBarController as UITabBarController:
                return tabBarController.selectedViewController
            default:
                return result
            }
        }
    }

    func showShareDialog(withItem item: Any) {
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

