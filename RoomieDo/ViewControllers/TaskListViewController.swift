//
//  TaskListViewController
//  RoomieDo
//
//  Created by Rui Vaz on 1/5/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import UIKit
import CoreData


class TaskListViewController: UIViewController {
    
    var viewModel: TaskListViewModel!
    
    lazy var tableView: UITableView = {
        let tbl = UITableView()
        tbl.register(TaskListCellView.self, forCellReuseIdentifier: String(describing: TaskListCellView.self))
        tbl.dataSource = self
        tbl.delegate = self
        tbl.tableFooterView = UIView()
        return tbl
    }()
    
    convenience init(viewModel: TaskListViewModel) {
        self.init()
        self.viewModel = viewModel
        initialize()
    }
    
    private func initialize() {
        // Add subviews
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Navigation items
        navigationItem.title = "My Tasks"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addButtonPressed)
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Actions
    @objc fileprivate func addButtonPressed(_ sender: UIBarButtonItem) {
        // Uncomment these lines
        let addViewModel = viewModel.addViewModel()
            let addVC = EditTaskViewController(viewModel: addViewModel)
            navigationController?.pushViewController(addVC, animated: true)
    }
}

extension Selector {
    fileprivate static let addButtonPressed = #selector(TaskListViewController.addButtonPressed(_:))
}

// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListCellView.self)) as! TaskListCellView
        cell.textLabel?.text = viewModel.title(at: indexPath.row)
        cell.detailTextLabel?.text = viewModel.dueDateText(at: indexPath.row)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editViewModel = viewModel.editViewModel(at: indexPath.row)
        let editVC = EditTaskViewController(viewModel: editViewModel)
        navigationController?.pushViewController(editVC, animated: true)
    }
}
