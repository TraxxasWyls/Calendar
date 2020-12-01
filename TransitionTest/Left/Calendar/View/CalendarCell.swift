//
//  CalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarCell: FSCalendarCell {

    var selectionLayer = CAShapeLayer()

    enum SelectionType: Int {
        case none
        case single
        case leftBorder
        case middle
        case rightBorder
    }
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel.layer)
        configureSelecitonLayer()
        configureShapeLayer()
    }

    func configureSelecitonLayer() {
        selectionLayer.fillColor = UIColor.red.withAlphaComponent(0.7).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
    }

    func configureShapeLayer() {
        shapeLayer.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.frame = bounds.insetBy(dx: 1, dy: 1)
        selectionLayer.frame = contentView.bounds
        
        if selectionType == .middle {
            selectionLayer.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayer.bounds,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.width / 2,
                    height: selectionLayer.frame.width / 2
                )
            ).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayer.bounds,
                byRoundingCorners: [.topRight, .bottomRight],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.width / 2,
                    height: selectionLayer.frame.width / 2
                )
            ).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(selectionLayer.frame.height, selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(
                ovalIn: CGRect(
                    x: contentView.frame.width / 2 - diameter / 2,
                    y: contentView.frame.height / 2 - diameter / 2,
                    width: diameter, height: diameter
                )
            ).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
