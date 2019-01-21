//
//  Task+CoreDataProperties.swift
//  RoomieDo
//
//  Created by Jenelle Feole on 1/20/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dueDate: NSDate
    @NSManaged public var reminder: String
    @NSManaged public var repeats: String
    @NSManaged public var taskName: String
    @NSManaged public var category: String

}
