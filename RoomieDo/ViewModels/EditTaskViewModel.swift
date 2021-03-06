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
                if let taskName = newValue {
                    task.taskName = taskName
                }
            }
        }
        
        var dueDate: Date? {
            get {
                return task.dueDate as Date?
            }
            set {
                if let dueDate = newValue {
                    task.dueDate = dueDate as NSDate
                }
            }
        }
        
        let reminderOptions: [String] = [Task.Reminder.none.rawValue,
                                         Task.Reminder.oneMinute.rawValue,
                                         Task.Reminder.tenMinutes.rawValue,
                                         Task.Reminder.halfHour.rawValue,
                                         Task.Reminder.oneHour.rawValue,
                                         Task.Reminder.oneDay.rawValue]
        var reminder: String? {
            get {
                return task.reminder
            }
            set {
                if let reminder = newValue {
                    task.reminder = reminder
                }
            }
        }
        
        
        let repeatOptions: [String] = [Task.RepeatFrequency.never.rawValue,
                                       Task.RepeatFrequency.daily.rawValue,
                                       Task.RepeatFrequency.weekly.rawValue,
                                       Task.RepeatFrequency.monthly.rawValue,
                                       Task.RepeatFrequency.annually.rawValue]
        
        var repeatFrequency: String? {
            get {
                return task.repeats
            }
            set {
                if let repeats = newValue {
                    task.repeats = repeats
                }
            }
        }
        
        // MARK: - Life Cycle
        
        init(task: Task) {
            self.task = task
        }
        
        // MARK: - Actions
        
        func save() {
            NotificationCenter.default.post(name: .saveToDoNotification, object: nil, userInfo: [ Notification.Name.saveToDoNotification : task ])
        }
        
        func delete() {
            NotificationCenter.default.post(name: .deleteToDoNotification, object: nil, userInfo: [ Notification.Name.deleteToDoNotification : task ])
        }
    }
}

extension Notification.Name {
    static let deleteToDoNotification = Notification.Name("delete todo")
    static let saveToDoNotification = Notification.Name("save todo")

}
