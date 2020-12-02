//
//  HapticFeedback.swift
//  TheRun
//
//  Created by incetro on 29/11/2019.
//  Copyright © 2019 Incetro Inc. All rights reserved.
//

import UIKit

// MARK: - ImpactHapticFeedbackStyle

public enum ImpactHapticFeedbackStyle: Hashable {
    case light
    case medium
    case heavy
}

// MARK: - HapticFeedback

final public class HapticFeedback {

    // MARK: - Properties

    /// Current impact generators
    private lazy var impactGenerator: [ImpactHapticFeedbackStyle: UIImpactFeedbackGenerator] = [
        .light: UIImpactFeedbackGenerator(style: .light),
        .medium: UIImpactFeedbackGenerator(style: .medium),
        .heavy: UIImpactFeedbackGenerator(style: .heavy)
    ]

    /// Selection generator isntance
    private lazy var selectionGenerator = UISelectionFeedbackGenerator()

    /// Notification generator instance
    private lazy var notificationGenerator = UINotificationFeedbackGenerator()

    // MARK: - Initializers

    public init() {
    }

    // MARK: - Useful

    /// Prepare some tap
    public func prepareTap() {
        selectionGenerator.prepare()
    }

    /// Tap feedback
    public func tap() {
        selectionGenerator.selectionChanged()
    }

    /// Prepare for some impact action
    /// - Parameter style: some impact style
    public func prepareImpact(_ style: ImpactHapticFeedbackStyle) {
        impactGenerator[style]?.prepare()
    }

    /// Generate some impact feedback
    /// - Parameter style: some impact style
    public func impact(_ style: ImpactHapticFeedbackStyle) {
        impactGenerator[style]?.impactOccurred()
    }

    /// Generate success feedback
    public func success() {
        notificationGenerator.notificationOccurred(.success)
    }

    /// Prepare error feedback
    public func prepareError() {
        notificationGenerator.prepare()
    }

    /// Generate error feedback
    public func error() {
        notificationGenerator.notificationOccurred(.error)
    }
}
