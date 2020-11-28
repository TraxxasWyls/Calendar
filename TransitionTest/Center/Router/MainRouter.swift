//
//  MainRouter.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation
import UIKit

final class MainRouter: Router {

}

// MARK: - UserProfileRouterInput

extension MainRouter: MainRouterInput {

    func openLeft(with state: String) {
        transitionHandler
            .openModule(
                LeftModule.self
            )
            .to(.navigation(style: .push))
            .perform()

    }

    func openRight() {
        transitionHandler
            .openModule(
                RightModule.self
            )
            .perform()
    }

    func openCentral() {
        transitionHandler
            .openModule(
                CenterModule.self
            )
            .perform()
    }

}
