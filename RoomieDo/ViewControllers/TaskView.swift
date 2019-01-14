//
//  TaskView.swift
//  RoomieDo
//
//  Created by Rui Vaz on 1/5/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import UIKit
import CoreData


class TaskView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TaskCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(taskName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else {
            fatalError()
        }
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(taskName, forKeyPath: "name")
        
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func unwindFromAddNewTask(_ sender: UIStoryboardSegue) {
        if sender.source is NewTaskView {
            if let senderVC = sender.source as? NewTaskView {
                if !senderVC.task.isEmpty {
                    self.save(taskName: senderVC.task)
                    self.tableView.reloadData()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TaskView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.value(forKey: "name") as? String
        
        return cell
    }
}
