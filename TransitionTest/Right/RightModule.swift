//
//  RightModule.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation

final class RightModule: Module {

    static func instantiate() -> RightViewController {
        RightViewController()
    }

    typealias View = RightViewController

    typealias Input = RightViewControllerInput

}
