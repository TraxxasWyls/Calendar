//
//  DIYViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//
// Мне не нравится как часто я определял isFirst...
// И немного не логичные уточнения на 208 строке и 211

import Foundation
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    private let gregorian = Calendar(identifier: .gregorian)

    private var calendar = FSCalendar()

    /// Состояния для границ отрезка
    private enum Condition {
        case didDeselect
        case didSelect
        case shouldDeselect
        case shouldSelect
    }

    /// Состояние левой границы
    private var ConditionOfFirstDate: Condition = .didDeselect

    /// Правой
    private var ConditionOfSecondDate: Condition = .didDeselect

    /// Левая грацица, при изменении которой автоматически
    /// контролируются некотрые состояния
    private var firstDate: Date? {
        didSet {
            if firstDate != nil {
                ConditionOfFirstDate = .didSelect
            } else {
                ConditionOfFirstDate = .didDeselect
            }
        }
    }

    /// Правая грацица, при изменении которой автоматически
    /// контролируются некотрые состояния, а также она следит за тем,
    /// чтобы всегда соблюдалось условие:  направления отрезка слева направо
    private var secondDate: Date? {
        didSet {
            if let secondDate = secondDate,
               let firstDate = firstDate,
               firstDate > secondDate {
                swap(&self.firstDate, &self.secondDate)
            }
            if secondDate != nil {
                ConditionOfSecondDate = .didSelect
            } else {
                ConditionOfSecondDate = .didDeselect
            }
        }
    }

    // MARK:- Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCalendar()
        configureNavigation()
        setupCalendar(dataSource: self, delegate: self)
        view.addSubview(calendar)
    }

    func configureCalendar() {
        calendar.allowsMultipleSelection = true
        calendar.scrollDirection = .vertical
        calendar.scrollEnabled = true
        calendar.pagingEnabled = false
        calendar.firstWeekday = 2
        calendar.placeholderType = .none
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.red
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true
        let scopeGesture = UIPanGestureRecognizer(
            target: calendar,
            action: #selector(calendar.handleScopeGesture(_:))
        )
        calendar.addGestureRecognizer(scopeGesture)
    }

    func configureNavigation() {
        let todayItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(self.todayItemClicked(sender:)))
        self.navigationItem.rightBarButtonItem = todayItem
    }

    func configureView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        title = "Calendar"
    }

    func setupCalendar(dataSource: FSCalendarDataSource, delegate: FSCalendarDelegate) {
        if let navigationController = navigationController {
            calendar.frame = CGRect(
                x: 0,
                y: navigationController.navigationBar.frame.maxY,
                width: view.frame.size.width,
                height: view.frame.size.height
            )
        }
        calendar.dataSource = dataSource
        calendar.delegate = delegate
    }

    @objc
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: true)
    }

    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    // MARK:- FSCalendarDelegate

    /// Обработка нажатия на ячейку ведущего к выделению
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate

        /// Ситуации, когда у нас выделен только сегодняшний день
        if calendar.selectedDates.count == 1,
           !isSecondDate,
           !isFirstDate {
            switch ConditionOfFirstDate {
            case .shouldDeselect:
                calendar.select(firstDate)
                ConditionOfFirstDate = .didSelect
                secondDate = date
            default:
                firstDate = date
                secondDate = nil
            }
        }
        /// Только сегодня и первая дата
        if calendar.selectedDates.count == 2,
           !isSecondDate,
           !isFirstDate {
            if let secondDate = secondDate {
                if date < secondDate {
                    if !calendar.selectedDates.contains(secondDate) {
                        self.secondDate = date
                    } else {
                        firstDate = date
                    }
                } else {
                    if let firstDate = firstDate,
                       !calendar.selectedDates.contains(firstDate) {
                        self.firstDate = self.secondDate
                    }
                    self.secondDate = date
                }
            } else {
                secondDate = date
                self.configureVisibleCells()
                return
            }
        }
        /// Дата находится в отрезке между первой и второй
        if let firstDate = firstDate,
           let secondDate = secondDate {
            if date.isInRange(firstDate, secondDate) {
                let side = date.sideInRange(firstDate, secondDate)
                switch side {
                case .right:
                    calendar.deselect(secondDate)
                    self.secondDate = date
                default:
                    calendar.deselect(firstDate)
                    self.firstDate = date
                }
            } else { /// Дата находится вне отрезка между первой и второй
                if date > secondDate {
                    self.secondDate = date
                    calendar.deselect(secondDate)
                }
                if date < firstDate {
                    self.firstDate = date
                    calendar.deselect(firstDate)
                }
            }
        }
        /// Последняя ситуация когда нажали на один из краев
        if isFirstDate || isSecondDate {
            /// Позовляет с менять состояние удержанием
            if let gestureRecognizer = calendar.gestureRecognizers?.first,
               gestureRecognizer.state == .failed {
                if isFirstDate {
                    ConditionOfFirstDate = .didSelect
                }
                if isSecondDate {
                    ConditionOfSecondDate = .didSelect
                }
                return
            }
            calendar.deselect(date)
            self.calendar(calendar,didDeselect: date)
        }
        self.configureVisibleCells()
    }

    /// Обработка промежуточного состояния
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if isFirstDate {
            ConditionOfFirstDate = .shouldDeselect
        }
        if isSecondDate {
            ConditionOfSecondDate = .shouldDeselect
        }
        /// Отмена отрезка если обе в промежуточном состоянии
        if ConditionOfFirstDate == .shouldDeselect,
           ConditionOfSecondDate == .shouldDeselect,
           let firstDate = firstDate,
           let secondDate = secondDate {
            calendar.deselect(firstDate)
            calendar.deselect(secondDate)
            self.firstDate = nil
            self.secondDate = nil
            self.calendar(calendar,didDeselect: firstDate)
            self.calendar(calendar,didDeselect: secondDate)
        }
        return true
    }

    /// Обработка отмены выделения
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if isFirstDate {
            firstDate = secondDate
            secondDate = nil
        }
        if isSecondDate {
            secondDate = nil
        }
        self.configureVisibleCells()
    }

    // MARK: - Private
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    /// Определения какой  слой поставить в соответсвие для выделения
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as? CalendarCell)
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        var selectionType = CalendarCell.SelectionType.none
        if isFirstDate || isSecondDate
            || date == calendar.today {
            selectionType = .single
        }
        if let secondDate = secondDate,
           let firstDate = firstDate {
            if  date.isInRange(firstDate, secondDate){
                selectionType = .middle
            }
            if calendar.selectedDates.contains(date) {
                if date == firstDate {
                    selectionType = .leftBorder
                }
                if date == secondDate {
                    selectionType = .rightBorder
                }
            }
        }
        if selectionType == .none {
            diyCell?.selectionLayer.isHidden = true
            return
        }
        diyCell?.selectionLayer.isHidden = false
        diyCell?.selectionType = selectionType
    }
}
