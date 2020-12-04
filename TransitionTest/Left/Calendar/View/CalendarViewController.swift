//
//  CalendarViewController.swift
//  TransitionTest
//
//  Created by Дмитрий Савинов on 20.11.2020.
//

import Foundation
import FSCalendar

// MARK: - CalendarViewController

final class CalendarViewController: UIViewController {

    // MARK: - Condition

    /// State of boundary dates of the selected segment
    private enum Condition {
        case didDeselect
        case didSelect
        case shouldDeselect
        case shouldSelect
    }

    // MARK: - Properties

    /// HapticFeedback instance
    private let hapticFeedback = HapticFeedback()

    /// FSCalendar instance
    private var calendar = FSCalendar()

    /// Weak Day View for calendar
    private var weakDayView: UIView?

    /// State of the left border of the selected segment
    private var ConditionOfFirstDate: Condition = .didDeselect

    /// State of the right border of the selected segment
    private var ConditionOfSecondDate: Condition = .didDeselect

    /// Left date  of the selected segment
    private var firstDate: Date? {
        didSet {
            if let firstDate = firstDate {
                ConditionOfFirstDate = .didSelect
                calendar.setCurrentPage(firstDate, animated: true)
            } else {
                ConditionOfFirstDate = .didDeselect
                if let today = calendar.today {
                    calendar.setCurrentPage(today, animated: true)
                }
            }
        }
    }

    /// Right date of the selected segment
    private var secondDate: Date? {
        didSet {
            if let secondDate = secondDate {
                ConditionOfSecondDate = .didSelect
                calendar.setCurrentPage(secondDate, animated: true)
            } else {
                if let firstDate = firstDate {
                    calendar.setCurrentPage(firstDate, animated: true)
                }
                ConditionOfSecondDate = .didDeselect
            }
            if let secondDate = secondDate,
               let firstDate = firstDate,
               firstDate > secondDate {
                swap(&self.firstDate, &self.secondDate)
            }
        }
    }

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCalendar()
        configureCalendarAppereance()
        configureNavigation()
        setupCalendar(dataSource: self, delegate: self)
        view.addSubview(calendar)
    }

    // MARK: - Private

    private func configureCalendar() {
        calendar.allowsMultipleSelection = true
        calendar.scrollDirection = .vertical
        calendar.scrollEnabled = true
        calendar.pagingEnabled = false
        calendar.firstWeekday = 2
        calendar.placeholderType = .none
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.selectionColor = UIColor.red
        let scopeGesture = UIPanGestureRecognizer(
            target: calendar,
            action: #selector(calendar.handleScopeGesture(_:))
        )
        calendar.addGestureRecognizer(scopeGesture)
        calendar.calendarWeekdayView.backgroundColor = .tertiarySystemGroupedBackground
    }

    private func configureCalendarAppereance() {
        calendar.appearance.titleFont = UIFont(name: "Helvetica", size: 18);
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 0)
        calendar.rowHeight = 50
        calendar.appearance.headerTitleFont = UIFont(name: "Helvetica", size: 18);
        calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: -10)
    }

    private func configureNavigation() {
        let todayItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayItemClicked(sender:)))
        navigationItem.rightBarButtonItem = todayItem
        if let navigationController = navigationController,
           let weakDayView = weakDayView {
            navigationController.navigationBar.frame = CGRect(
                x: 0,
                y: navigationController.navigationBar.frame.midY,
                width: view.frame.size.width,
                height: navigationController.navigationBar.frame.height + weakDayView.fs_height + 5
            )
            navigationController.navigationBar.addSubview(weakDayView)
        }
    }

    private func configureView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        title = "Calendar"
    }

    private func setupCalendar(dataSource: FSCalendarDataSource, delegate: FSCalendarDelegate) {
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

    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            configure(cell: cell, for: date!, at: position)
        }
    }

    /// Selection layer configuration for calendar cells
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as? CalendarCell)
        var selectionType = CalendarCell.SelectionType.none
        if let secondDate = secondDate,
           let firstDate = firstDate {
            if date.isInRange(firstDate, secondDate){
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

    @objc private func todayItemClicked(sender: AnyObject) {
        calendar.setCurrentPage(Date(), animated: true)
    }
}

// MARK: - FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        configure(cell: cell, for: date, at: position)
    }
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        hapticFeedback.impact(.light)
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
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
                configureVisibleCells()
                return
            }
        }
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
            } else {
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
        if isFirstDate || isSecondDate {
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
        configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        hapticFeedback.impact(.heavy)
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if isFirstDate {
            ConditionOfFirstDate = .shouldDeselect
        }
        if isSecondDate {
            ConditionOfSecondDate = .shouldDeselect
        }
        if ConditionOfFirstDate == .shouldDeselect,
           ConditionOfSecondDate == .shouldDeselect,
           let firstDate = firstDate,
           let secondDate = secondDate {
            calendar.deselect(firstDate)
            calendar.deselect(secondDate)
            self.firstDate = nil
            self.secondDate = nil
            configureVisibleCells()
        }
        self.calendar(calendar,didSelect: date, at: .current)
        return false
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        hapticFeedback.impact(.light)
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if isFirstDate {
            firstDate = secondDate
            secondDate = nil
        }
        if isSecondDate {
            secondDate = nil
        }
        configureVisibleCells()
    }
}

// MARK:- FSCalendarDelegateAppearance

extension CalendarViewController: FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if date == calendar.today {
            return UIColor.red
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date == calendar.today {
            print("opana")
            return UIColor.blue
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        UIColor.systemGray
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        UIColor.systemBackground
    }
}

extension FSCalendarWeekdayView {

    func configureAppearance() {
        self.removeFromSuperview()
    }
}
