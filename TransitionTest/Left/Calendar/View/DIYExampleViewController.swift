//
//  DIYViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation
import FSCalendar

class DIYExampleViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate weak var calendar: FSCalendar!
    private var firstDate: Date? {
        didSet {
            print("first \(self.formatter.string(from: self.firstDate ?? Date()))")
        }
    }
    private var secondDate: Date? {
        didSet {
                if let secondDate = secondDate,
                   let firstDate = firstDate,
                   firstDate > secondDate {
                    swap(&self.firstDate, &self.secondDate)
                }
            print("second \(self.formatter.string(from: self.secondDate ?? Date()))")
        }
    }
    
    // MARK:- Life cycle
    
    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        self.view = view
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 800
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: view.frame.size.width, height: height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.scrollDirection = .vertical
        calendar.scrollEnabled = true
        calendar.pagingEnabled = false
        calendar.firstWeekday = 2
        calendar.placeholderType = .none
        view.addSubview(calendar)
        self.calendar = calendar
        
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.eventSelectionColor = UIColor.red
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)

        let todayItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(self.todayItemClicked(sender:)))
        self.navigationItem.rightBarButtonItem = todayItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if calendar.selectedDates.count == 1,
           !isSecondDate,
           !isFirstDate {
            firstDate = date
            secondDate = nil
        }
        if calendar.selectedDates.count == 2,
           !isSecondDate,
           !isFirstDate {
            if let secondDate = secondDate {
                if date < secondDate {
                    if !calendar.selectedDates.contains(secondDate) {
                        self.secondDate = self.firstDate
                    }
                    firstDate = date
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
            calendar.deselect(date)
            self.calendar(calendar,didDeselect: date)
        }
        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        let isFirstDate = date == firstDate
        let isSecondDate = date == secondDate
        if (isFirstDate) {
            firstDate = secondDate
            secondDate = nil
        }
        if (isSecondDate) {
            secondDate = nil
        }
        self.configureVisibleCells()
    }
    
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        var selectionType = SelectionType.none
        if date == secondDate || date == firstDate
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
            diyCell.selectionLayer.isHidden = true
            return
        }
        diyCell.selectionLayer.isHidden = false
        diyCell.selectionType = selectionType
    }
}
