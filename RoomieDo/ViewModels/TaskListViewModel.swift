//
//  TaskListViewModel.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/13/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import Foundation
import CoreData

extension TaskListViewController {
    
    class TaskListViewModel {
        
        private var managedContext: NSManagedObjectContext
        private var tasks: [Task]
        private lazy var dateFormatter: DateFormatter = {
            let fmtr = DateFormatter()
            fmtr.dateFormat = "EEEE, MMM d"
            return fmtr
        }()
        
        var numberOfTasks: Int {
            return tasks.count
        }
        
        private func task(at index: Int) -> Task {
            return tasks[index]
        }
        
        func dueDateText(at index: Int) -> String {
            let date = task(at: index).dueDate
            return dateFormatter.string(from: date as Date)
        }
        
        func title(at index: Int) -> String {
            return task(at: index).taskName
        }
        
        func editViewModel(at index: Int) -> EditTaskViewController.ViewModel {
            let task = self.task(at: index)
            let editViewModel = EditTaskViewController.ViewModel(task: task)
            return editViewModel
        }
        
        func addViewModel() -> EditTaskViewController.ViewModel {
            let entity =
                NSEntityDescription.entity(forEntityName: "Task",
                                           in: managedContext)!
            
            let task = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
            
            tasks.append(task as! Task)
            let addViewModel = EditTaskViewController.ViewModel(task: task as! Task)
            return addViewModel
        }
        
        @objc private func saveToDo(_ notification: Notification) {
            do{
                // Save to persistent storage
                try self.managedContext.save()
                print("saved")
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        @objc private func removeToDo(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                let task = userInfo[Notification.Name.deleteToDoNotification] as? Task,
                let index = tasks.index(of: task) else {
                    return
            }
            // Remove from array
            tasks.remove(at: index)
            
            // Remove from persistent storage
            self.managedContext.delete(task)
            
            do{
                try self.managedContext.save()
                print("saved")
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
        
        init(tasks: [Task], managedContext: NSManagedObjectContext) {
            self.tasks = tasks
            self.managedContext = managedContext

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(removeToDo(_:)),
                                                   name: .deleteToDoNotification, object: nil)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveToDo(_:)),
                                                   name: .saveToDoNotification, object: nil)

        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
