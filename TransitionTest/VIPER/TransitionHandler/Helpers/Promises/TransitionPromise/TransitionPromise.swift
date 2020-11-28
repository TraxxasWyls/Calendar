//
//  TransitionPromise.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import UIKit

typealias PromiseAction = () throws -> Void

// MARK: - TransitionPromise

class TransitionPromise<T> {

    // MARK: Properties

    unowned var source: UIViewController
    var destination: UIViewController?
    var promise: PromiseAction?
    var type: T.Type
    private(set) var animated = true

    // MARK: - Initializers

    /// Initilization with source and destination
    ///
    /// - Parameters:
    ///   - source: Source UIViewController
    ///   - destination: Destination UIViewController
    ///   - type: ModuleInput type
    init(source: UIViewController, destination: UIViewController?, for type: T.Type) {
        self.source = source
        self.destination = destination
        self.type = type
    }

    // MARK: - Useful methods

    /// Configure destination ModuleInput
    ///
    /// It is most often used together with the `setModuleOutput`method for `ModuleInput` ,
    /// but also you can use it to configure simple data like title or some int, because plain data objects must be
    /// transmitted via special `openModule( :with data)` method
    ///
    /// - Parameter block: destination ModuleInput config block
    func then(_ block: @escaping TransitionConfigureBlock<T>) {

        var moduleInput: ModuleInput?

        if destination is UINavigationController {
            let targetController = (destination as? UINavigationController)?.topViewController ?? destination
            moduleInput = targetController?.moduleInput
        } else if let input = destination as? ModuleInput {
            moduleInput = input
        } else {
            moduleInput = destination?.moduleInput
        }

        let input = moduleInput.unwrap(
            as: T.self,
            TransitionHandlerError.custom("Cannot cast type '\(T.self)' to '\(moduleInput as Any)' object")
        )
        block(input)
        perform()
    }

    /// Set animate property
    ///
    /// - Parameter animate: animate property
    /// - Returns: Current promise
    func animate(_ animate: Bool) -> Self {
        self.animated = animate
        return self
    }

    /// Setup destination
    ///
    /// - Parameter block: setup block
    /// - Returns: Current promise
    func destination(_ block: (UIViewController) -> Void) -> Self {
        let destination = self.destination.unwrap(TransitionHandlerError.nilController("Destination"))
        block(destination)
        return self
    }

    /// Make transition
    func perform() {
        do {
            try promise?()
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Replace promise
    ///
    /// - Parameter completion: Current promise
    func promise( _ promise: @escaping PromiseAction) {
        self.promise = promise
    }
}
