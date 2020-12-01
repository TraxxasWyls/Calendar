//
//  LeftModule.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation

final class LeftModule: Module {

    static func instantiate() -> CalendarViewController {
        CalendarViewController()
    }

    typealias View = CalendarViewController

    typealias Input = LeftViewControllerInput

}
