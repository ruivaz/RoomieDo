//
//  TaskListViewModel.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/13/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import Foundation

extension TaskListViewController {
    
    class TaskListViewModel {
        
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
            return dateFormatter.string(from: date)
        }
        
        func title(at index: Int) -> String {
            return task(at: index).taskName ?? ""
        }
        
        func editViewModel(at index: Int) -> EditTaskViewController.ViewModel {
            let task = self.task(at: index)
            let editViewModel = EditTaskViewController.ViewModel(task: task)
            return editViewModel
        }
        
        func addViewModel() -> EditTaskViewController.ViewModel {
            let task = Task()
            tasks.append(task)
            let addViewModel = EditTaskViewController.ViewModel(task: task)
            return addViewModel
        }
        
        @objc private func removeToDo(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                let task = userInfo[Notification.Name.deleteToDoNotification] as? Task,
                let index = tasks.index(of: task) else {
                    return
            }
            tasks.remove(at: index)
        }
        
        init(tasks: [Task]) {
            self.tasks = tasks
            
            NotificationCenter.default.addObserver(self, selector: #selector(removeToDo(_:)), name: .deleteToDoNotification, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
