//
//  CalendarCell.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation
import UIKit
import FSCalendar

// MARK: - CalendarCell

final class CalendarCell: FSCalendarCell {

    // MARK: - SelectionType

    enum SelectionType: Int {
        case none
        case single
        case leftBorder
        case middle
        case rightBorder
    }

    // MARK: - Properties

    /// Selection layer instance
    var selectionLayer = CAShapeLayer()

    /// Current cell selection type
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel.layer)
        configureSelecitonLayer()
        configureShapeLayer()
    }

    // MARK: - Private

    private func configureSelecitonLayer() {
        selectionLayer.fillColor = UIColor.red.withAlphaComponent(0.7).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
    }

    private func configureShapeLayer() {
        shapeLayer.isHidden = true
    }

    // MARK: - FSCalendarCell

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.frame = bounds.insetBy(dx: 1, dy: 1)
        selectionLayer.frame = contentView.bounds
        switch selectionType {
        case .middle:
            selectionLayer.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
        case .leftBorder:
            selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayer.bounds,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.width / 2,
                    height: selectionLayer.frame.width / 2
                )
            ).cgPath
        case .rightBorder:
            self.selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayer.bounds,
                byRoundingCorners: [.topRight, .bottomRight],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.width / 2,
                    height: selectionLayer.frame.width / 2
                )
            ).cgPath
        case .single:
            let diameter: CGFloat = min(selectionLayer.frame.height, selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(
                ovalIn: CGRect(
                    x: contentView.frame.width / 2 - diameter / 2,
                    y: contentView.frame.height / 2 - diameter / 2,
                    width: diameter, height: diameter
                )
            ).cgPath
        default:
            return
        }
    }
}
