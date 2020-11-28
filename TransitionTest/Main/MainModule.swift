//
//  MainModule.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation

final class MainModule: Module {

    static func instantiate() -> ViewController {
        ViewController()
    }

    typealias View = ViewController

    typealias Input = ViewControllerInput

}
