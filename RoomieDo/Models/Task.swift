//
//  Task.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/5/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import Foundation

class Task: Equatable {

    var taskName: String?

    var dueDate: Date

    fileprivate var reminderDate: Date?
    fileprivate var category_raw: String?
    fileprivate var repeats_raw: String

    init(taskName: String? = nil, dueDate: Date = Date(), reminderDate: Date? = nil, category_raw: String? = nil, repeats_raw: String = RepeatFrequency.never.rawValue) {
        self.taskName = taskName
        self.dueDate =  dueDate
        self.reminderDate = reminderDate
        self.category_raw = category_raw
        self.repeats_raw = repeats_raw
    }

    static func ==(_ lhs: Task, _ rhs: Task) -> Bool {
        return (lhs.taskName == rhs.taskName)
            && (lhs.dueDate == rhs.dueDate)
            && (lhs.reminderDate == rhs.reminderDate)
            && (lhs.category_raw == rhs.category_raw)
            && (lhs.repeats_raw == rhs.repeats_raw)
    }
}

// MARK: - Category, Repeat Frequency and Reminder
extension Task {

    enum Category: String {
        case personal = "Personal 😄"
        case home = "Home 🏠"
        case work = "Work 💼"
        case play = "Play 🎮"
        case health = "Health 🏋🏻‍♀️"
    }

    enum RepeatFrequency: String {
        case never = "Never"
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case annually = "Annually"
    }

    enum Reminder: String {
        case none = "None"
        case halfHour = "30 minutes before"
        case oneHour = "1 hour before"
        case oneDay = "1 day before"
        case oneWeek = "1 week before"

        var timeInterval: Double {
            switch self {
            case .none:
                return 0
            case .halfHour:
                return -1800
            case .oneHour:
                return -3600
            case .oneDay:
                return -86400
            case .oneWeek:
                return -604800
            }
        }
        
        static func fromInterval(_ interval: TimeInterval) -> Reminder {
            switch interval {
            case 1800:
                return .halfHour
            case 3600:
                return .oneHour
            case 86400:
                return .oneDay
            case 604800:
                return .oneWeek
            default:
                return .none
            }
        }
    }
}

// MARK: Computed variables
extension Task {
    var category: Category? {
        get {
            if let value = self.category_raw {
                return Category(rawValue: value)!
            }
            return nil
        }
        set {
            self.category_raw = newValue?.rawValue
        }
    }
    
    var repeats: RepeatFrequency {
        get {
            return RepeatFrequency(rawValue: self.repeats_raw)!
        }
        set {
            self.repeats_raw = newValue.rawValue
        }
    }
    
    var reminder: Reminder {
        get {
            if let date = self.reminderDate {
                let duration = date.seconds(from: self.dueDate)
                return Reminder.fromInterval(duration)
            }
            return .none
        }
        set {
            reminderDate = dueDate.addingTimeInterval(newValue.timeInterval)
        }
    }
}

extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> TimeInterval {
        let duration =  Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        return Double(abs(duration))
    }
}
