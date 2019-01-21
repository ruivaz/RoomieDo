//
//  EditTaskViewController
//  RoomieDo
//
//  Created by Rui Vaz on 1/6/19.
//  Copyright © 2019 Astrolab. All rights reserved.
//

import UIKit
import Eureka


class EditTaskViewController: FormViewController {

    var viewModel: ViewModel!
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        return formatter
    }()
    
    // MARK: - Life Cycle
    convenience init(viewModel: ViewModel) {
        self.init()
        self.viewModel = viewModel
        initialize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section()
            <<< TextRow() {
                $0.title = "Description"
                $0.placeholder = "e.g. Wash your clothes"
                $0.value = viewModel.title
                $0.onChange { [unowned self]  row in
                    self.viewModel.title = row.value
                }
                $0.add(rule: RuleRequired()) //1
                $0.validationOptions = .validatesOnChange //2
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            +++ Section()
            <<< DateTimeRow() {
                $0.dateFormatter = type(of: self).dateFormatter //1
                $0.title = "Due date" //2
                $0.value = viewModel.dueDate //3
                $0.minimumDate = Date() //4
                $0.onChange { [unowned self] row in //5
                    if let date = row.value {
                        self.viewModel.dueDate = date
                    }
                }
            }
        
            <<< PushRow<String>() { //1
                $0.title = "Repeats" //2
                $0.value = viewModel.repeatFrequency //3
                $0.options = viewModel.repeatOptions //4
                $0.onChange { [unowned self] row in //5
                    if let value = row.value {
                        self.viewModel.repeatFrequency = value
                    }
                }
            }
            +++ Section()
            <<< AlertRow<String>() {
                $0.title = "Reminder"
                $0.selectorTitle = "Remind me"
                $0.value = viewModel.reminder
                $0.options = viewModel.reminderOptions
                $0.onChange { [unowned self] row in
                    if let value = row.value {
                        self.viewModel.reminder = value
                    }
                }
            }
    }
    
    private func initialize() {
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: .deleteButtonPressed)
        navigationItem.leftBarButtonItem = deleteButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .saveButtonPressed)
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = .white
    }
    
    // MARK: - Actions
    @objc fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
        if form.validate().isEmpty {
            _ = navigationController?.popViewController(animated: true)
        }
        
        self.viewModel.save()
    }
    
    @objc fileprivate func deleteButtonPressed(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Delete this item?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
          self?.viewModel.delete()
          _ = self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(delete)
        alert.addAction(cancel)

        navigationController?.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Selectors
extension Selector {
    fileprivate static let saveButtonPressed = #selector(EditTaskViewController.saveButtonPressed(_:))
    fileprivate static let deleteButtonPressed = #selector(EditTaskViewController.deleteButtonPressed(_:))
}
