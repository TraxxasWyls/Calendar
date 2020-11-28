//
//  MainRouterInput.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation

protocol MainRouterInput: class, RouterInput {
    func openLeft(with state: String)
    func openRight()
    func openCentral()

}
