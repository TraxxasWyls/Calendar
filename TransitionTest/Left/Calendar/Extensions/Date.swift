//
//  Date.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 30.11.2020.
//

import Foundation

extension Date {
    
    public func isInRange(_ left: Date, _ right: Date) -> Bool {
        if (self < right && self > left) {
            return true
        }
        return false
    }

    public enum Side {
        case left
        case right
        case center
    }

    public func sideInRange(_ left: Date, _ right: Date) -> Side {
        let center = (right.timeIntervalSince1970 - left.timeIntervalSince1970) / 2
        let left = left.timeIntervalSince1970
        let current = self.timeIntervalSince1970 - left
        if current - center < 0 {
            return .left
        }
        if current - center == 0 {
            return .center
        }
        return .right
    }
}
