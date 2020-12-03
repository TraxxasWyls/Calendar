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
        setupTopBorderOfCell(color: .lightGray, width: 0.5)
//        let dateLabel = UILabel()
//        contentView.addSubview(dateLabel)
//        dateLabel.text = "LOL"
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
//        ])
        contentView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        contentView.viw
//        titleLabel.font = UIFont(name: "Kaiti SC", size: 25.0);
//        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.layer.insertSublayer(selectionLayer, below: titleLabel.layer)
        configureSelecitonLayer()
        configureShapeLayer()
    }

    // MARK: - Private

    private func setupTopBorderOfCell(color: UIColor, width: CGFloat)  {
        let layer = CALayer()
        layer.borderColor = color.withAlphaComponent(0.7).cgColor
        layer.borderWidth = width
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(layer)
    }

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
        let selectionLayerRect = CGRect(x: contentView.frame.origin.x,
                                        y: contentView.frame.origin.y + 7.5,
                                        width: contentView.frame.width,
                                        height: contentView.frame.height - 15
          )
        let selectionLayerLeftEdge = CGRect(x: contentView.frame.origin.x + 7,
                                        y: contentView.frame.origin.y + 7.5,
                                        width: contentView.frame.width - 7,
                                        height: contentView.frame.height - 15
          )
        let selectionLayerRightEdge = CGRect(x: contentView.frame.origin.x,
                                        y: contentView.frame.origin.y + 7.5,
                                        width: contentView.frame.width - 7,
                                        height: contentView.frame.height - 15
          )
        selectionLayer.frame = selectionLayerRect
        selectionLayer.bounds = selectionLayerRect
        switch selectionType {
        case .middle:
            selectionLayer.path = UIBezierPath(rect: selectionLayer.bounds).cgPath
        case .leftBorder:
            selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayerLeftEdge,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.height / 2,
                    height: selectionLayer.frame.height / 2
                )
            ).cgPath
        case .rightBorder:
            self.selectionLayer.path = UIBezierPath(
                roundedRect: selectionLayerRightEdge,
                byRoundingCorners: [.topRight, .bottomRight],
                cornerRadii: CGSize(
                    width: selectionLayer.frame.height / 2,
                    height: selectionLayer.frame.height / 2
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
