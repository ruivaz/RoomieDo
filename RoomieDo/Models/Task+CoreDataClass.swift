//
//  Task+CoreDataClass.swift
//  RoomieDo
//
//  Created by Jenelle Feole on 1/20/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//
//

import Foundation
import CoreData
import UserNotifications

public class Task: NSManagedObject {

}

extension Task {
    
    enum Category: String {
        case personal = "Personal"
        case home = "Home"
        case work = "Work"
        case play = "Play"
        case health = "Health"
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
        case oneMinute = "1 minute before"
        case tenMinutes = "10 minutes before"
        case halfHour = "30 minutes before"
        case oneHour = "1 hour before"
        case oneDay = "1 day before"
        
        var timeInterval: Double {
            switch self {
            case .none:
                return 0
            case .oneMinute:
                return -60
            case .tenMinutes:
                return -600
            case .halfHour:
                return -1800
            case .oneHour:
                return -3600
            case .oneDay:
                return -86400
            }
        }
        
        static func fromInterval(_ interval: TimeInterval) -> Reminder {
            switch interval {
            case 60:
                return .oneMinute
            case 600:
                return .tenMinutes
            case 1800:
                return .halfHour
            case 3600:
                return .oneHour
            case 86400:
                return .oneDay
            default:
                return .none
            }
        }
    }
}

extension Task {

    var uniqueId: String {
        get {
            return self.objectID.uriRepresentation().absoluteString
        }
    }

    var triggerDate: Date {
        get {
            return self.dueDate.addingTimeInterval(Reminder(rawValue: self.reminder)!.timeInterval) as Date
        }
    }

    public func activateNotification() {
        // Scheduling a notification with the same identifier will automatically remove any existing one

        // Configure notification content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: self.taskName, arguments: nil)
        content.sound = UNNotificationSound.default

        // Configure notification trigger
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: self.triggerDate)

        // TODO: create extension to calculate the Date Components for the repeats enum values
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // Create the request object
        let request = UNNotificationRequest(identifier: self.uniqueId, content: content, trigger: trigger)

        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }

    public func deactivateNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [self.uniqueId])
    }

}


extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> TimeInterval {
        let duration =  Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        return Double(abs(duration))
    }
}
