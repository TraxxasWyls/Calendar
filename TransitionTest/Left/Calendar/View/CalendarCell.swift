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

    public var lenghtOfSelection = 0

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
        setupTopBorderOfCell(color: .lightGray, width: 0.5)
        contentView.layer.insertSublayer(shapeLayer, below: titleLabel.layer)
        contentView.layer.borderColor = .none
        configureSelecitonLayer()
        configureShapeLayer()
    }

    // MARK: - Private

    private func setupTopBorderOfCell(color: UIColor, width: CGFloat)  {
        let layer = CALayer()
        layer.borderColor = color.withAlphaComponent(0.7).cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: -4, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
    }

    private func configureSelecitonLayer() {
        selectionLayer.fillColor = UIColor.black.withAlphaComponent(0.8).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
    }

    private func configureShapeLayer() {
        shapeLayer.isHidden = false
        shapeLayer.fillColor = UIColor.black.cgColor
    }

    func removeSelecitonLayer() {
//        contentView.layer.sublayers?.removeAll(where: {
//            $0 == selectionLayer
//        })
        lenghtOfSelection = 0
    }

    // MARK: - FSCalendarCell

    override func layoutSubviews() {
        super.layoutSubviews()
        let selectionLayerLeftEdge = CGRect(x: contentView.frame.minX,
                                            y: shapeLayer.frame.origin.y,
                                            width: contentView.frame.width * (CGFloat(lenghtOfSelection)),
                                            height: shapeLayer.frame.height
          )
        let selectionLayerRightEdge = CGRect(x: contentView.frame.width/2,
                                             y: shapeLayer.frame.origin.y,
                                             width: -(contentView.frame.width * CGFloat(lenghtOfSelection)),
                                             height: shapeLayer.frame.height
          )
        let selectionLayerMiddle = CGRect(x: contentView.frame.minX,
                                          y: shapeLayer.frame.origin.y,
                                          width: contentView.frame.width * (CGFloat(lenghtOfSelection)),
                                          height: shapeLayer.frame.height
          )
        switch selectionType {
        case .middle:
            contentView.layer.insertSublayer(selectionLayer, above: shapeLayer)
            selectionLayer.path = UIBezierPath(rect: selectionLayerMiddle).cgPath
        case .leftBorder:
            contentView.layer.insertSublayer(selectionLayer, above: shapeLayer)
            selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayerLeftEdge,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: CGSize(
                    width: contentView.frame.height / 2,
                    height: shapeLayer.frame.height / 2
                )
            ).cgPath
        case .rightBorder:
            contentView.layer.insertSublayer(selectionLayer, above: shapeLayer)
            selectionLayer.path = UIBezierPath(rect: selectionLayerRightEdge).cgPath
        default:
            return
        }
    }
}
//selectionLayer.path = UIBezierPath(
//    roundedRect: selectionLayerLeftEdge,
//    byRoundingCorners: [.topLeft, .bottomLeft],
//    cornerRadii: CGSize(
//        width: selectionLayer.frame.height / 2,
//        height: selectionLayer.frame.height / 2
//    )
//).cgPath
//self.selectionLayer.path = UIBezierPath(
//    roundedRect: selectionLayerRightEdge,
//    byRoundingCorners: [.topRight, .bottomRight],
//    cornerRadii: CGSize(
//        width: selectionLayer.frame.height / 2,
//        height: selectionLayer.frame.height / 2
//    )
//).cgPath
