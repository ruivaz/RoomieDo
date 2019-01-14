//
//  Task.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/5/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import Foundation

class Task {

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
    }
}
