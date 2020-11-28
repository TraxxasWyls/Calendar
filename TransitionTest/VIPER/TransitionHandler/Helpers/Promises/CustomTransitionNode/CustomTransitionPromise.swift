//
//  CustomTransitionPromise.swift
//  TransitionHandler
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2019 incetro. All rights reserved.
//

import UIKit

typealias TransitionBlock = (_ source: UIViewController, _ destination: UIViewController) -> Void

// MARK: - CustomTransitionPromise

final class CustomTransitionPromise<T> {

    private unowned var source: UIViewController
    private var destination: UIViewController
    private var type: T.Type

    /// Initilization with source and destination
    ///
    /// - Parameters:
    ///   - source: Source UIViewController
    ///   - destination: Destination UIViewController
    ///   - type: ModuleInput type
    init(source: UIViewController, destination: UIViewController, for type: T.Type) {
        self.source = source
        self.destination = destination
        self.type = type
    }

    /// Gives you basic template to create custom transition
    /// - Parameter block: closure that contains setup for transition
    /// - Returns: Promise with setups
    func transition(_ block: @escaping TransitionBlock) -> TransitionPromise<T> {
        let promise = TransitionPromise(source: source, destination: destination, for: type)
        promise.promise {
            block(self.source, self.destination)
        }
        return promise
    }
}
