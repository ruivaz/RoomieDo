//
//  EditTaskViewModel.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/13/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import Foundation


extension EditTaskViewController {
    
    class ViewModel {
        
        private let task: Task
        
        var title: String? {
            get {
                return task.taskName
            }
            set {
                task.taskName = newValue
            }
        }
        
        var dueDate: Date {
            get {
                return task.dueDate
            }
            set {
                task.dueDate = newValue
            }
        }
        
        let reminderOptions: [String] = [Task.Reminder.none.rawValue,
                                         Task.Reminder.halfHour.rawValue,
                                         Task.Reminder.oneHour.rawValue,
                                         Task.Reminder.oneDay.rawValue,
                                         Task.Reminder.oneWeek.rawValue]
        var reminder: String? {
            get {
                return task.reminder.rawValue
            }
            set {
                if let value = newValue {
                    task.reminder = Task.Reminder(rawValue: value)!
                }
            }
        }
        
        
        let repeatOptions: [String] = [Task.RepeatFrequency.never.rawValue,
                                       Task.RepeatFrequency.daily.rawValue,
                                       Task.RepeatFrequency.weekly.rawValue,
                                       Task.RepeatFrequency.monthly.rawValue,
                                       Task.RepeatFrequency.annually.rawValue]
        
        var repeatFrequency: String {
            get {
                return task.repeats.rawValue
            }
            set {
                task.repeats = Task.RepeatFrequency(rawValue: newValue)!
            }
        }
        
        // MARK: - Life Cycle
        
        init(task: Task) {
            self.task = task
        }
        
        // MARK: - Actions
        func delete() {
            NotificationCenter.default.post(name: .deleteToDoNotification, object: nil, userInfo: [ Notification.Name.deleteToDoNotification : task ])
        }
    }
}

extension Notification.Name {
    static let deleteToDoNotification = Notification.Name("delete todo")
}
