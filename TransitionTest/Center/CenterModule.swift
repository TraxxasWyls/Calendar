//
//  CenterModule.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation

final class CenterModule: Module {

    static func instantiate() -> CenterViewController {
        CenterViewController()
    }

    typealias View = CenterViewController

    typealias Input = CenterViewControllerInput

}

