//
//  UIViewController.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit

// MARK: - TransitionHandler

extension UIViewController: TransitionHandler {

    var moduleInput: ModuleInput? {
        if let provider = self as? ViewOutputProvider {
            if let result = provider.viewOutput {
                return result
            } else {
                fatalError("Your UIViewController must return ModuleInput!")
            }
        } else {
            fatalError("Your UIViewController must implement protocol 'ViewOutputProvider'!")
        }
    }

    func openModule<M>(
        _ moduleType: M.Type
    ) -> ViperTransitionPromise<M.Input> where M: Module, M.View: UIViewController {
        let destination = M.instantiate()
        let promise = ViperTransitionPromise(source: self, destination: destination, for: M.Input.self)
        promise.promise { [weak self] in
            self?.present(destination, animated: true, completion: nil)
        }
        return promise
    }

    func openModule<M>(
        _ moduleType: M.Type,
        withData data: M.Data
    ) -> ViperTransitionPromise<M.Input> where M: AdvancedModule, M.View: UIViewController {
        let destination = M.instantiate(withData: data)
        let promise = ViperTransitionPromise(source: self, destination: destination, for: M.Input.self)
        promise.promise { [weak self] in
            self?.present(destination, animated: true, completion: nil)
        }
        return promise
    }

    func closeCurrentModule() -> CloseTransitionPromise {
        let close = CloseTransitionPromise(source: self)
        close.promise { [unowned self] in
            if let parent = self.parent {
                if let navigationController = parent as? UINavigationController {
                    if navigationController.children.count > 1 {
                        navigationController.popViewController(animated: close.isAnimated)
                    } else if let presentedViewController = navigationController.presentedViewController {
                        presentedViewController.dismiss(animated: close.isAnimated)
                    } else if navigationController.children.count == 1 {
                        navigationController.dismiss(animated: close.isAnimated)
                    }
                } else {
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                }
            } else if self.presentingViewController != nil {
                self.dismiss(animated: close.isAnimated)
            }
        }
        return close
    }
}

// MARK: - UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {
}

