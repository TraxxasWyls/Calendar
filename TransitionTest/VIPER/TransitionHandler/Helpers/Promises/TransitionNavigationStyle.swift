//
//  TransitionNavigationStyle.swift
//  Workzilla
//
//  Created by incetro on 27/11/2019.
//  Copyright © 2017 Incetro. All rights reserved.
//

import Foundation

// MARK: - TransitionNavigationStyle

/// Style for your navigation between modules
///
/// - `push`: Push your module to `UINavigationController`
/// - `pop`: Pop your module in `UINavigationController`
/// - `present`: Present your module in `UINavigationController`
enum TransitionNavigationStyle {
    case push
    case pop
    case present
    case single
}
