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


extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> TimeInterval {
        let duration =  Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        return Double(abs(duration))
    }
}
