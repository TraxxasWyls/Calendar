//
//  TransitionHandler.swift
//  TransitionHandler
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2019 incetro. All rights reserved.
//

import Foundation

// MARK: - TransitionHandlerError

/// Error that you can use to find out what is going bad with your `transition`
///
/// - `custom`:  Allows you to pass your own string for an error type that is not specified in the enum
/// - `nilController`: Used if the transition is not possible due to the lack of `source` or `destination`
/// - `cast`: To track type cast errors during configuration of `promises`
enum TransitionHandlerError: LocalizedError {

    case custom(String)
    case nilController(String)
    case cast(from: String, to: String)
}
